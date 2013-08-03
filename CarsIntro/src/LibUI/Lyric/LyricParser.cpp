#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <malloc/malloc.h>
//#include <//ASSERT.h>
//#include <iconv.h>
//#include "iconvTranscode.h"
#include <assert.h>
//#include <iconv.h>
//#include "base64.h"
//#include "utility.h"
#include "LyricParser.h"

//#define IOS_UTF8_ENCODING

#define LYRIC_CONTENT_ENCRYPTED
#define LYRIC_TIMESTAMP_ENCRYPTED

////////////////////////////////////////////////////////////////////////////////
//
bool CLyricLine::IsScheduleMatched(int schedule) const
{
    if (schedule < m_nTimestamp)
        return false;
    if (m_nElapsed <= 0)
        return true;
    if (schedule < m_nTimestamp + m_nElapsed)
        return true;
    return false;
}

const CLyricWord* CLyricLine::GetWord(int index) const
{
	if ((size_t)index >= m_vWords.size())
		return NULL;
	return m_vWords[index];
}

int CLyricLine::GetCorsorOfWord(int schedule) const
{
    for (LyricWordsType::const_iterator itr = m_vWords.begin(); itr != m_vWords.end(); itr++)
	{
		CLyricWord* pLyricWord = *itr;
        if (schedule <= pLyricWord->time || schedule < pLyricWord->time + pLyricWord->elapse)
			return (int)(itr - m_vWords.begin());
	}
    return m_vWords.size();
}

bool CLyricLine::AddWord(const char* word, int count, int time, int elapse)
{
	if (!word || count <= 0)
		return false;
	if (time < 0 || elapse <= 0)
		return false;
	//ASSERT((int)strlen(word) >= count);
    CLyricWord* pWord = new CLyricWord(m_strLyric.size(), count, time, elapse);
    if (!pWord)
        return false;
	m_strLyric.append(word, count);
	m_vWords.push_back(pWord);
    m_nElapsed = time + elapse;
	return true;
}

void CLyricLine::Clear()
{
	for (LyricWordsType::iterator itr = m_vWords.begin(); itr != m_vWords.end(); itr++)
	{
		delete *itr;
	}
	m_vWords.clear();
	m_nTimestamp = 0;
	m_nElapsed = 0;
}

int CLyricLine::GetOriginalLyricText(char* buffer, int size) const
{
	if (!buffer)
		return 0;
	int count = 0;
	// time
	int minute, second, millisecond;
	millisecond = m_nTimestamp % 1000;
	second = m_nTimestamp / 1000;
	minute = second / 60;
	second %= 60;
	count += sprintf (buffer + count, "[%02d:%02d.%03d]", minute, second, millisecond);
	if (m_vWords.empty())
	{
		count += snprintf(buffer + count, size - count, "%s", m_strLyric.c_str());//snprintf?
	}
	else
	{
		for (LyricWordsType::const_iterator itr = m_vWords.begin(); itr != m_vWords.end(); itr++)
		{
			const CLyricWord* pWord = *itr;
			char* temp = (char*)alloca(pWord->count + 1);
			strncpy(temp, m_strLyric.c_str() + pWord->pos, pWord->count);
			temp[pWord->count] = 0;
			count += snprintf (buffer + count, size - count, "<%d,%d>%s", pWord->time, pWord->elapse, temp);//snprintf?
			if (count >= size)
				break;
		}
	}
	return count;
}

////////////////////////////////////////////////////////////////////////////////
//
const CLyricLine* CLyricParser::GetLyricLine(int index) const
{
	if ((size_t)index >= m_vLineList.size())
		return NULL;
	return m_vLineList[index];
}

// retrieve the lyric line cursor of schedule.
// this line could be matched the schedule, or could be the next line immediate the schedule,
// return total lines count if schedule is bigger than the last line.
int CLyricParser::GetLineCursorOfSchedule(int schedule) const
{
    for (LyricLinesType::const_iterator itr = m_vLineList.begin(); itr != m_vLineList.end(); itr++)
	{
		CLyricLine* pLyricLine = *itr;
		int timestamp = pLyricLine->GetTimestamp();
		int elapse = pLyricLine->GetElapsed();
        if (schedule <= timestamp || schedule < timestamp + elapse)
			return (int)(itr - m_vLineList.begin());
	}
    return m_vLineList.size();
}
// added by plj
CLyricParagraph CLyricParser::GetParagraphCursorOfSchedule(int schedule) const
{
    CLyricParagraph ret = {0, m_vLineList.size() - 1, 0, 0};
    if (m_vParagraphList.empty())
        return ret;
    
    CLyricParagraph* pParam = NULL;
    for (LyricParagraphType::const_iterator itr = m_vParagraphList.begin(); itr != m_vParagraphList.end(); itr++)
	{
		pParam = *itr;
        int startTime = pParam->startTime;
        int endTime = pParam->endTime;
        if (schedule >= startTime && schedule < endTime) {
            
            ret.startLine = GetLineCursorOfSchedule(startTime + GUIDE_TIME);
            if (schedule - startTime >= 0 && schedule - startTime < GUIDE_TIME) {
                ret.startTime = startTime;
                ret.endTime = startTime + GUIDE_TIME;
            }

            ret.endLine = GetLineCursorOfSchedule(endTime);

            return ret;
        }
	}
    ret.startLine = -1;
    return ret;
}

////////////////////////////////////////////////////////////////////////////////
//

const char* CLyricParser::GetFileExtension(const char* lpszFilePath, char szFileExtension[MAX_PATH_CAPACITY])
{
    if (!lpszFilePath)
        return NULL;
    // 去掉歌词的路径 '/29677.lrcx'为p
    const char* p = strrchr(lpszFilePath, '/');
    if (!p)
        return NULL;
	
    p++;  //去掉'/'
    const char* p2 = strrchr(p + 1, '.');  // .lrcx为p2
    if (!p2 || !*(++p2))  // 同时也去掉p2的'.'
        return NULL;
    
    strncpy(szFileExtension, p2, MAX_PATH);  //为什么不直接获取p2, 而通过p这个中间变量再获取p2，目录里面也没有'.'
    szFileExtension[MAX_PATH] = 0;
    
    return szFileExtension;
}
bool CLyricParser::LoadLyricFile(const char* file)
{
    if (!file)
        return false;

    bool bVerbatim = true;
    char temp[MAX_PATH_CAPACITY];
    GetFileExtension(file, temp);
    strlwr(temp);
    if (!strcmp(temp, "lrcx")) {
        bVerbatim = true;
    } else if (!strcmp(temp, "lrc")) {
        bVerbatim = false;
    } else {
        return false;
    }
    
	FILE* fp = fopen(file, "rb");
	if (!fp)
		return false;
	
	fseek(fp, 0, SEEK_END);
	int len = ftell(fp);
	if (len <= 0)
	{
		fclose(fp);
		return false;
	}
	fseek(fp, 0, SEEK_SET);
	char* buffer = new char[len];
	len = fread(buffer, 1, len, fp);
	fclose(fp);
    
//	printf("歌词内容=%s", buffer);
	bool ret = ParseLyricInternal(buffer, len, true);
	
	delete [] buffer;
//	m_strLyricFile = file;
    
	return ret;
}
bool CLyricParser::LoadLyricData(const char *buffer, int length, bool bVerbatim)
{
    bool ret = ParseLyricInternal(buffer, length, true);
    return ret;
}



void CLyricParser::Clear()
{
	for (LyricLinesType::iterator itr = m_vLineList.begin(); itr != m_vLineList.end(); itr++)
	{
		delete *itr;
	}
	m_vLineList.clear();
    for (LyricParagraphType::iterator itr = m_vParagraphList.begin(); itr != m_vParagraphList.end(); itr++)
	{
		delete *itr;
	}
    m_vParagraphList.clear();
    m_bVerbatim = false;
}

// verify lyric timestamp and elapse.
bool CLyricParser::VerifyTimestamp(int duration)
{
	for (LyricLinesType::iterator itr = m_vLineList.begin(); itr != m_vLineList.end(); itr++)
    {
		CLyricLine* pLyricLine = *itr;
        if (pLyricLine->GetElapsed() > 0)
            continue;
        int elapsed = pLyricLine->GetElapsed();
        if (elapsed > 0)
            continue;
        
        if (itr == m_vLineList.end() - 1) {
            elapsed = duration - pLyricLine->GetTimestamp();
        } else {
            elapsed = (*(itr+1))->GetTimestamp() - pLyricLine->GetTimestamp();
        }
        if (elapsed <= 0)
            elapsed = 500;
        
        pLyricLine->SetElapsed(elapsed);
    }
    return true;
}

bool CLyricParser::DivideLyricLine(int index, const vector<int>& vPos)
{
    if ((size_t)index >= m_vLineList.size() || vPos.empty())
        return false;
    if (vPos.size() == 1)
        return true;
    
    CLyricLine* pLine = m_vLineList[index];
    m_vLineList.erase(m_vLineList.begin() + index);
    for (int i = vPos.size() - 1; i >= 0; i--)
    {
        int start = vPos[i];
        int end = i+1 < vPos.size() ? vPos[i+1] : pLine->GetWordCount();
        CLyricLine* pLineNew = new CLyricLine;
        int offset = pLine->GetWord(start)->time;
        int timestamp = pLine->GetTimestamp() + offset;
        pLineNew->SetTimestamp(timestamp);
        while (start < end) {
            const CLyricWord* pWord = pLine->GetWord(start++);
            pLineNew->AddWord(pLine->GetText() + pWord->pos, pWord->count, pWord->time - offset, pWord->elapse);
        }
        m_vLineList.insert(m_vLineList.begin() + index, pLineNew);
    }
    delete pLine;
    return true;
}

bool CLyricParser::DecryptLyricEx(char* pchData, int length, const char* pszKeys)
{
#ifdef LYRIC_CONTENT_ENCRYPTED
	if (!pchData || length <= 0)
		return false;
    
	if (!pszKeys || !*pszKeys)
		return true;
    
	char* pchCur = pchData;
	const char* pchEnd = pchData + length;
	const char* pchKeyCur = pszKeys;
	const char* pchKeyEnd = pszKeys + strlen(pszKeys);
	while (pchCur < pchEnd)
	{
		*pchCur++ ^= *pchKeyCur++;
		if (pchKeyCur == pchKeyEnd)
			pchKeyCur = pszKeys;
	};
#endif  // LYRIC_CONTENT_ENCRYPTED
	return true;
}

static bool isAllAscii(const char *str)
{
	for (char *p = (char *)str; *p != '\0'; p++) {
		if ((unsigned char)*p >= 128)
			return false; 
	}
	return true;
}

bool CLyricParser::AddLyricLineInternal(int time, const char* lyric, int length, bool bVerbatim)
{
	////ASSERT (time >= 0);
	if (!lyric || length <= 0)
		return true;
    
    // added by plj
	bool needAddGuide = false;
	int index = 0;
	if (m_bNeedParagraph) {
		if (m_vLineList.empty())
		{
			if (time >= GUIDE_TIME)
			{
				needAddGuide = true;
			}
			needAddGuide = true; // plj. <6s时,怎么办
		}
		else
		{
			index = m_vLineList.size();
			CLyricLine *lastLine = *(m_vLineList.end() - 1);
			if (time - lastLine->GetTimestamp() - lastLine->GetElapsed() >= GUIDE_TIME)
			{
				needAddGuide = true;
			}
		}
	}
	CLyricLine* pLyricLine = ParseLyricLineInternal(lyric, length, bVerbatim);
	if (!pLyricLine)
		return false;
	pLyricLine->SetTimestamp(time);
    
    if (m_bNeedParagraph) {
		if (needAddGuide) {
			int startTime = time - GUIDE_TIME;
			CLyricParagraph* paragraph = new CLyricParagraph;
			paragraph->startTime = startTime;
			paragraph->endTime = time;
			m_vParagraphList.push_back(paragraph);
		} else {
			if (!m_vParagraphList.empty()) {
				CLyricParagraph* paragraph = m_vParagraphList[m_vParagraphList.size() - 1];
				paragraph->endTime = time + pLyricLine->GetElapsed();
			}
		}
	}
    
    m_vLineList.push_back(pLyricLine);
    
    // 拆分空格. added by plj
    if (m_bNeedParagraph)
    {
	    if (!isAllAscii(pLyricLine->GetText())) {
		    std::vector<int> vpos;
		    vpos.push_back(0);
		    for (int i = 0; i < pLyricLine->GetWordCount(); i++) {
			    const char *ss = pLyricLine->GetText();
			    int p = pLyricLine->GetWord(i)->pos;
			    int l = pLyricLine->GetWord(i)->count;
				char word[l+1];
				strncpy(word, ss+p, l);
				if (isAllAscii(word))
					continue;
			    if (ss[p] == ' ') {
				    vpos.push_back(i);
			    }
			    if (ss[p+l-1] == ' ' && (i+1) < pLyricLine->GetWordCount()) {
				    vpos.push_back(i+1);
			    }
		    }
		    if (vpos.size() > 1) {
			    DivideLyricLine(index, vpos);
		    }
	    }
    }
    
	return true;
}

#include <errno.h>
bool CLyricParser::ParseLyricInternal(const char* pchLyricData, int length, bool bVerbatim)
{
	if (!pchLyricData || length <= 0)
		return false;
    
	Clear();
    m_bVerbatim = bVerbatim;
	
	const char* pchLineStart = pchLyricData;
	const char* pchLyricEnd = pchLyricData + length;
    
	while (pchLineStart < pchLyricEnd)
	{
		const char* pchLineEnd = strchr (pchLineStart, '\n');
		if (!pchLineEnd)
			pchLineEnd = pchLyricEnd;
		//ASSERT (pchLineStart <= pchLineEnd);
		ParseLyricLine(pchLineStart, pchLineEnd - pchLineStart, bVerbatim);
		pchLineStart = pchLineEnd + 1;
	}
    
#ifdef IOS_UTF8_ENCODING
    delete [] buffer;
#endif
    
	return true;
}

bool CLyricParser::ParseLyricLine(const char* pchLyricLine, int length, bool bVerbetim)
{
	//ASSERT (pchLyricLine != NULL && length >= 0);
    
	const char* pchCur = pchLyricLine;
	const char* pchEnd = pchLyricLine + length;
    //printf("歌词信息=%s\n", pchCur);
	// skip white space characters
	for ( ; pchCur < pchEnd; pchCur++) {
		char ch = *pchCur;
		if (ch != ' ' && ch != '\t')
			break;
	}
    
	// trim white space characters
	for ( ; pchEnd > pchCur; pchEnd--) {
		char ch = pchEnd[-1];
		if (ch != ' ' && ch != '\t' && ch != '\r')
			break;
	}
    
	//ASSERT (pchCur <= pchEnd);
	if (pchCur == pchEnd)
		return false;
    
	// try as lyric line
	if (AddLyricLine(pchCur, pchEnd - pchCur, bVerbetim))
		return true;
    
	// try as tag line
	if (AddLyricTag(pchCur, pchEnd - pchCur))
		return true;
    
	return false;
}

#define NUMBER_TO_STRING2(x) #x
#define NUMBER_TO_STRING(x)	NUMBER_TO_STRING2(x)

bool CLyricParser::AddLyricTag(const char* line, int length)
{
	//ASSERT (line != NULL && length > 0);
    
	char name[LYRIC_TAG_MAX_SIZE+1];
	char value[LYRIC_TAG_MAX_SIZE+1];
	//int field = snscanf (line, length, "[%"NUMBER_TO_STRING(LYRIC_TAG_MAX_SIZE)"[^:]:%"NUMBER_TO_STRING(LYRIC_TAG_MAX_SIZE)"[^]:\n]]", name, value);
	int field = sscanf (line, "[%"NUMBER_TO_STRING(LYRIC_TAG_MAX_SIZE)"[^:]:%"NUMBER_TO_STRING(LYRIC_TAG_MAX_SIZE)"[^]:\n]]", name, value);
	if (field != 2)
		return false;
    
	strlwr(name);
	if (!strcmp (name, "ver")) {
		strlwr(value);
		int major = 0, subver = 0;
		if (2 != sscanf(value, "v%4d.%4d", &major, &subver))
			return false;
		SetVersion(major, subver);
	} else if (!strcmp (name, "ti")) {
		SetTitle(value);
	} else if (!strcmp (name, "ar")) {
		SetArtist(value);
	} else if (!strcmp (name, "al")) {
		SetAlbum(value);
	} else if (!strcmp (name, "by")) {
		SetProvider(value);
	} else if (!strcmp (name, "kuwo")) {
		int key = 0;

		if (1 != sscanf(value, "%4o", &key))
			return false;
		printf("LRCXKEY=%s,%d\n", value, key);
		SetKey(key);
	} else if (!strcmp(name, "offset")) {
		int offset;
		if (1 != sscanf(value, "%d", &offset))
			return false;
		printf("offset=%s,%d\n", value, offset);
		SetOffset(offset);
	} else {
		return false;
	}
	return true;
}

bool CLyricParser::AddLyricLine(const char* line, int length, bool bVerbetim)
{
	//ASSERT (line != NULL && length > 0);
    
	int minute = 0, second = 0, millisecond = 0;
	//int field = snscanf (line, length, "[%4d:%2d.%3d]", &minute, &second, &millisecond);
	int field = sscanf (line, "[%4d:%2d.%3d]", &minute, &second, &millisecond);
	if (field != 3)
		return false;
    
	char temp[16];
	//if (1 != snscanf (line, length, "[%*[0-9:].%3[0-9]]", temp))
    if (1 != sscanf (line, "[%*[0-9:].%3[0-9]]", temp))
        return false;
	if (strlen(temp) < 3)
		millisecond *= 10;
    
	int time = (minute * 60 + second) * 1000 + millisecond;
	if (time < 0)
		return false;
	
	// plj. add offset
	time -= GetOffset();
	if (time < 0)  time = 0;
	const char* pStart = strchr(line, ']');
	if (!pStart)
		return false;
	pStart++;
	return AddLyricLineInternal(time, pStart, length - (pStart - line), bVerbetim);
}

CLyricLine* CLyricParser::ParseLyricLineInternal(const char* lyric, int length, bool bVerbatim)
{
	if (!lyric || length <= 0)
		return NULL;
	CLyricLine* pLyricLine = new CLyricLine();
        
	if (!bVerbatim)
	{
		pLyricLine->SetLyric(lyric, length);
	}
	else
	{
		int time, elapse;
		char text[512];
		const char* pCur = lyric;
		const char* pEnd = lyric + length;
		while (pCur < pEnd)
		{
			for ( ; pCur < pEnd; pCur++)
			{
				if (*pCur != ' ' && *pCur != '\t')
					break;
			}
			//int field = snscanf(pCur, length, "<%d,%d>%511[^<\n]", &time, &elapse, text );
            int field = sscanf(pCur, "<%d,%d>%511[^<\n]", &time, &elapse, text );
			if (field == 3)
			{
				DecryptTimestamp(time, elapse);
//                printf("'%s' [time=%d, elapse=%d]\n", text, time, elapse);
				pLyricLine->AddWord(text, strlen(text), time, elapse);
			}
			pCur = strchr(pCur + 1, '<');
			if (!pCur)
				break;
		}
	}
	return pLyricLine;
}

bool CLyricParser::DecryptTimestamp(int& time, int& elapse)
{
#ifdef LYRIC_TIMESTAMP_ENCRYPTED
	int key1 = GetKey() / 10;
	int key2 = GetKey() % 10;
	if (!key1 || !key2)
		return false;
	int time1 = (time + elapse) / (2 * key1);
	int elapse1 = (time - elapse) / (2 * key2);
	time = time1;
	elapse = elapse1;
#endif // LYRIC_TIMESTAMP_ENCRYPTED
	return true;
}

// 循环变量s，将字符变为小写字符
char* CLyricParser::strlwr(char* s)
{
    char* p = s;
    while (*p != '\0') {
        if (isupper(*p)) {
            *p = tolower(*p);
        }
        ++p;
    }
    return s;
}
