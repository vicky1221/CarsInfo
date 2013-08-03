// LyricParser.h

#ifndef _KUWO_LYRIC_PARSER_H__
#define _KUWO_LYRIC_PARSER_H__

#include <string.h>
#include <utility>
using std::pair;
#include <string>
using std::string;
#include <vector>
using std::vector;

#pragma warning (disable:4996)


#define MAX_PATH 255
#define MAX_PATH_CAPACITY   (MAX_PATH + 1)

#define GUIDE_TIME 6000
#define GUIDE_DURATION 3000


struct CLyricWord
{
	int pos;			// 本词文字起始位置
	int count;			// 本词包含字数
	int time;			// 本词播放起始时间（相对于句首时刻，毫秒）
	int elapse;			// 本次播放持续时间（毫秒）

	CLyricWord(int p = 0, int c = 0, int t = 0, int e = 0)
		: pos(p)
		, count(c)
		, time(t)
		, elapse(e)
	{ }
    
    bool IsScheduleMatched(int schedule) const {
        return (time <= schedule) && (time + elapse) > schedule;
    }
};

class CLyricLine
{
public:
	CLyricLine(int time = 0, int elapse = 0, const char* lyric = NULL)
		: m_nTimestamp(time)
		, m_nElapsed(elapse)
	{
		m_strLyric.reserve(32);
		m_vWords.reserve(16);
		if (lyric)
			m_strLyric = lyric;
	}

	~CLyricLine() {
		Clear();
	}
    
public:
    bool IsNullLine() const {
        return m_strLyric.empty();
    }
    int GetTextLength() const {
        return m_strLyric.size();
    }

    operator const char*() const {
        return GetText();
    }
    
	const char* GetText() const {
		return m_strLyric.c_str();
	}
	int GetTimestamp() const {
		return m_nTimestamp;
	}
	int GetElapsed() const {
		if (m_nElapsed)
			return m_nElapsed;
		if (!m_vWords.empty())
			return (*m_vWords.rbegin())->time + (*m_vWords.rbegin())->elapse;
		return 0;
	}
	
    bool IsScheduleMatched(int schedule) const;
    
    int GetWordCount() const {
        return m_vWords.size();
    }
	int GetCorsorOfWord(int schedule) const;
	const CLyricWord* GetWord(int index) const;

public:
	void SetTimestamp(int time) {
		//ASSERT(time >= 0);
		m_nTimestamp = time;
	}

	void SetElapsed(int elapse) {
		m_nElapsed = elapse;
        if (m_vWords.size() == 1) {
            CLyricWord* pWord = m_vWords[0];
            if (pWord->elapse == 0)
                pWord->elapse = elapse;
        }
	}

	// 用于逐句歌词，逐字歌词用AddWord
	void SetLyric(const char* lyric, int length) {
		m_strLyric.assign(lyric, length);
        //m_vWords.push_back(new CLyricWord(0, length, 0, 0));
	}

	bool AddWord(const char* word, int count, int time, int elapse);
    
	void Clear();

public:
	int GetOriginalLyricText(char* buffer, int size) const;

private:
	string m_strLyric;				// 歌词一行
	int m_nTimestamp;				// 歌词播放起始时间（毫秒）
	int m_nElapsed;					// 歌词一行播放时间（毫秒）

	typedef vector<CLyricWord*> LyricWordsType;
	LyricWordsType m_vWords;	// 按词拆分的词位置信息列表
};

// 段落信息. added by plj
struct CLyricParagraph
{
    int startLine;
    int endLine;
    int startTime;
    int endTime;
};

#define LYRIC_TAG_MAX_SIZE 63

struct CLyricInfo
{
	int version;				// 歌词文件版本号
	int key;					// 加解密key

	char szTitle[LYRIC_TAG_MAX_SIZE+1];			// 歌曲名
	char szArtist[LYRIC_TAG_MAX_SIZE+1];			// 演唱者
	char szAlbum[LYRIC_TAG_MAX_SIZE+1];			// 专辑
	char szWriter[LYRIC_TAG_MAX_SIZE+1];			// 词作者
	char szComposer[LYRIC_TAG_MAX_SIZE+1];		// 曲作者
	char szProvider[LYRIC_TAG_MAX_SIZE+1];		// 歌词提供者
	int offset; //plj. 歌词偏移

	CLyricInfo() {
		memset (this, 0, sizeof(*this));
	}
};

class CLyricParser
{
public:
	CLyricParser() : m_bVerbatim(false), m_bNeedParagraph(false) {
		m_vLineList.reserve(32);
        m_vParagraphList.reserve(2);
	}

	~CLyricParser() {
		Clear();
	}

public:
    bool IsLyricValid() const {
        return !m_vLineList.empty();
    }
    
    bool IsVerbatim() const {
        return m_bVerbatim;
    }
    
public:
	int GetVersion() const {
		return m_tagInfo.version;
	}
	int GetMajorVersion() const {
		return (m_tagInfo.version >> 8) & 0xFF;
	}
	int GetSubVersion() const {
		return m_tagInfo.version & 0xFF;
	}
	bool SerVersion(int version) {
		m_tagInfo.version = version;
		return true;
	}
	bool SetVersion(int major, int subver) {
		m_tagInfo.version = major << 8 | subver;
		return true;
	}

	int GetKey() {
		return m_tagInfo.key;
	}
	bool SetKey(int key) {
		m_tagInfo.key = key;
		return true;
	}

	const char* GetTitle() const {
//		if (!m_tagInfo.szTitle[0])
//			return NULL;
		return m_tagInfo.szTitle;
	}
	bool SetTitle(const char* title) {
		if (!title)
			return false;
		strncpy (m_tagInfo.szTitle, title, 31);//strncpy?
		return true;
	}

	const char* GetArtist() const {
//		if (!m_tagInfo.szArtist[0])
//			return NULL;
		return m_tagInfo.szArtist;
	}
	bool SetArtist(const char* artist) {
		if (!artist)
			return false;
		strncpy (m_tagInfo.szArtist, artist, 31);//strncpy?
		return true;
	}

	const char* GetAlbum() const {
//		if (!m_tagInfo.szAlbum[0])
//			return NULL;
		return m_tagInfo.szAlbum;
	}
	bool SetAlbum(const char* album) {
		if (!album)
			return false;
		strncpy (m_tagInfo.szAlbum, album, 31);//strncpy?
		return true;
	}

	const char* GetWriter() const {
//		if (!m_tagInfo.szWriter[0])
//			return NULL;
		return m_tagInfo.szWriter;
	}
	bool SetWriter(const char* writer) {
		if (!writer)
			return false;
		strncpy (m_tagInfo.szWriter, writer, 31);//strncpy?
		return true;
	}

	const char* GetComposer() const {
//		if (!m_tagInfo.szComposer[0])
//			return NULL;
		return m_tagInfo.szComposer;
	}
	bool SetComposer(const char* composer) {
		if (!composer)
			return false;
		strncpy (m_tagInfo.szComposer, composer, 31);//strncpy?
		return true;
	}

	const char* GetProvider() const {
//		if (!m_tagInfo.szProvider[0])
//			return NULL;
		return m_tagInfo.szProvider;
	}
	bool SetProvider(const char* provider) {
		if (!provider)
			return false;
		strncpy (m_tagInfo.szProvider, provider, 31);//strncpy?
		return true;
	}
	// plj
	int GetOffset() const {
		return m_tagInfo.offset;
	}
	bool SetOffset(int offset) {
		m_tagInfo.offset = offset;
		return true;
	}
	void setParagraph(bool p) {
		m_bNeedParagraph = p;
	}

public:
	int GetLineCount() const {
		return m_vLineList.size();
	}
    
    // retrieve the lyric line cursor of schedule.
    // this line could be matched the schedule, or could be the next line immediate the schedule,
    // return total lines count if schedule is bigger than the last line.
    int GetLineCursorOfSchedule(int schedule) const;
    
    CLyricParagraph GetParagraphCursorOfSchedule(int schedule) const;
    
	const CLyricLine* GetLyricLine(int index) const;
    
public:
	bool LoadLyricFile(const char* file);
	bool LoadLyricData(const char* buffer, int length, bool bVerbatim);
	bool ParseLyric(const char* pchLyricData, int length);
	bool ParseLyricEx(const char* pchLyricData, int length);
    

    
	void Clear();
    
    // verify lyric timestamp and elapse.
    bool VerifyTimestamp(int duration);
    
    bool DivideLyricLine(int index, const vector<int>& vPos);

private:
	bool DecryptLyricEx(char* pchData, int length, const char* pszKeys);

    const char* GetFileExtension(const char* lpszFilePath, char szFileExtension[MAX_PATH_CAPACITY]);
	bool AddLyricLineInternal(int time, const char* lyric, int length, bool bVerbatim);
    
	bool ParseLyricInternal(const char* pchLyricData, int length, bool bVerbatim);
	bool ParseLyricLine(const char* pchLyricLine, int length, bool bVerbetim);
    
	bool AddLyricTag(const char* line, int length);
	bool AddLyricLine(const char* line, int length, bool bVerbetim);

private:
	CLyricLine* ParseLyricLineInternal(const char* lyric, int length, bool bVerbatim);

	bool DecryptTimestamp(int& time, int& elapse);
	char* strlwr(char* s);
private:
	string m_strLyricFile;
	CLyricInfo m_tagInfo;
    bool m_bVerbatim;
	bool m_bNeedParagraph;

	typedef vector<CLyricLine*> LyricLinesType;
	LyricLinesType m_vLineList;
    typedef vector<CLyricParagraph*> LyricParagraphType;
    LyricParagraphType m_vParagraphList;
};

#endif
