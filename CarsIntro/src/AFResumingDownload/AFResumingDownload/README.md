<img src="https://github.com/AFNetworking/AFNetworking/raw/gh-pages/afnetworking-logo.png" alt="AFNetworking" title="AFNetworking" style="display:block; margin: 10px auto 30px auto;" class="center">

AFNetworking is a delightful networking library for iOS and Mac OS X. It's built on top of [NSURLConnection](http://developer.apple.com/library/mac/#documentation/Cocoa/Reference/Foundation/Classes/NSURLConnection_Class/Reference/Reference.html), [NSOperation](http://developer.apple.com/library/mac/#documentation/Cocoa/Reference/NSOperation_class/Reference/Reference.html), and other familiar Foundation technologies. It has a modular architecture with well-designed, feature-rich APIs that are a joy to use. For example, here's how easy it is to get JSON from a URL:

``` objective-c
NSURL *url = [NSURL URLWithString:@"http://api.twitter.com/1/statuses/public_timeline.json"];
NSURLRequest *request = [NSURLRequest requestWithURL:url];
AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
    NSLog(@"Public Timeline: %@", JSON);
} failure:nil];
[operation start];
```

Perhaps the most important feature of all, however, is the amazing community of developers who use and contribute to AFNetworking every day. AFNetworking powers some of the most popular and critically-acclaimed apps on the iPhone, iPad, and Mac. 

Choose AFNetworking for your next project, or migrate over your existing projects—you'll be happy you did!

## How To Get Started

- [Download AFNetworking](https://github.com/AFNetworking/AFNetworking/zipball/master) and try out the included Mac and iPhone example apps
- Read the ["Getting Started" guide](https://github.com/AFNetworking/AFNetworking/wiki/Getting-Started-with-AFNetworking), [FAQ](https://github.com/AFNetworking/AFNetworking/wiki/AFNetworking-FAQ), or [other articles in the wiki](https://github.com/AFNetworking/AFNetworking/wiki)
- Check out the [complete documentation](http://afnetworking.org/Documentation/) for a comprehensive look at the APIs available in AFNetworking
- Watch the [NSScreencast episode about AFNetworking](http://nsscreencast.com/episodes/6-afnetworking) for a quick introduction to how to use it in your application
- Questions? [Stack Overflow](http://stackoverflow.com/questions/tagged/afnetworking) is the best place to find answers

## Overview

AFNetworking is architected to be as small and modular as possible, in order to make it simple to use and extend.

<table>
  <tr><th colspan="2" style="text-align:center;">Core</th></tr>
  <tr>
    <td><a href="http://afnetworking.org/Documentation/Classes/AFURLConnectionOperation.html">AFURLConnectionOperation</a></td>
    <td>An <tt>NSOperation</tt> that implements the <tt>NSURLConnection</tt> delegate methods.</td>
  </tr>

  <tr><th colspan="2" style="text-align:center;">HTTP Requests</th></tr>

  <tr>
    <td><a href="http://afnetworking.org/Documentation/Classes/AFHTTPRequestOperation.html">AFHTTPRequestOperation</a></td>
    <td>A subclass of <tt>AFURLConnectionOperation</tt> for requests using the HTTP or HTTPS protocols. It encapsulates the concept of acceptable status codes and content types, which determine the success or failure of a request.</td>
  </tr>
  <tr>
    <td><a href="http://afnetworking.org/Documentation/Classes/AFJSONRequestOperation.html">AFJSONRequestOperation</a></td>
    <td>A subclass of <tt>AFHTTPRequestOperation</tt> for downloading and working with JSON response data.</td>
  </tr>
  <tr>
    <td><a href="http://afnetworking.org/Documentation/Classes/AFXMLRequestOperation.html">AFXMLRequestOperation</a></td>
    <td>A subclass of <tt>AFHTTPRequestOperation</tt> for downloading and working with XML response data.</td>
  </tr>
  <tr>
    <td><a href="http://afnetworking.org/Documentation/Classes/AFPropertyListRequestOperation.html">AFPropertyListRequestOperation</a></td>
    <td>A subclass of <tt>AFHTTPRequestOperation</tt> for downloading and deserializing objects with <a href="http://developer.apple.com/library/mac/documentation/Cocoa/Conceptual/PropertyLists/index.html">property list</a> response data.</td>
  </tr>

  <tr><th colspan="2" style="text-align:center;">HTTP Client</th></tr>
  <tr>
    <td><a href="http://afnetworking.org/Documentation/Classes/AFHTTPClient.html">AFHTTPClient</a></td>
    <td>
      Captures the common patterns of communicating with an web application over HTTP, including:
      
      <ul>
        <li>Making requests from relative paths of a base URL</li>
        <li>Setting HTTP headers to be added automatically to requests</li>
        <li>Authenticating requests with HTTP Basic credentials or an OAuth token</li>
        <li>Managing an <tt>NSOperationQueue</tt> for requests made by the client</li>
        <li>Generating query strings or HTTP bodies from an <tt>NSDictionary</tt></li>
        <li>Constructing multipart form requests</li>
        <li>Automatically parsing HTTP response data into its corresponding object representation</li>
        <li>Monitoring and responding to changes in network reachability</li>
      </ul>
    </td>
  </tr>

  <tr><th colspan="2" style="text-align:center;">Images</th></tr>
  <tr>
    <td><a href="http://afnetworking.org/Documentation/Classes/AFImageRequestOperation.html">AFImageRequestOperation</a></td>
    <td>A subclass of <tt>AFHTTPRequestOperation</tt> for downloading an processing images.</td>
  </tr>
  <tr>
    <td><a href="http://afnetworking.org/Documentation/Categories/UIImageView+AFNetworking.html">UIImageView+AFNetworking</a></td>
    <td>Adds methods to `UIImageView` for loading remote images asynchronously from a URL.</td>
  </tr>
</table>

## Example Usage

### XML Request

``` objective-c
NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.flickr.com/services/rest/?method=flickr.groups.browse&api_key=b6300e17ad3c506e706cb0072175d047&cat_id=34427469792%40N01&format=rest"]];
AFXMLRequestOperation *operation = [AFXMLRequestOperation XMLParserRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, NSXMLParser *XMLParser) {
  XMLParser.delegate = self;
  [XMLParser parse];
} failure:nil];
[operation start];
```

### Image Request

``` objective-c
UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
[imageView setImageWithURL:[NSURL URLWithString:@"http://i.imgur.com/r4uwx.jpg"] placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
```

### API Client Request

``` objective-c
// AFGowallaAPIClient is a subclass of AFHTTPClient, which defines the base URL and default HTTP headers for NSURLRequests it creates
[[AFGowallaAPIClient sharedClient] getPath:@"/spots/9223" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"Name: %@", [responseObject valueForKeyPath:@"name"]);
    NSLog(@"Address: %@", [responseObject valueForKeyPath:@"address.street_address"]);
} failure:nil];
```

### File Upload with Progress Callback

``` objective-c
NSURL *url = [NSURL URLWithString:@"http://api-base-url.com"];
AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"avatar.jpg"], 0.5);
NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
    [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
}];

AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
[operation setUploadProgressBlock:^(NSInteger bytesWritten, NSInteger totalBytesWritten, NSInteger totalBytesExpectedToWrite) {
    NSLog(@"Sent %d of %d bytes", totalBytesWritten, totalBytesExpectedToWrite);
}];
[operation start];
```

### Streaming Request

``` objective-c
NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8080/encode"]];

AFHTTPRequestOperation *operation = [[[AFHTTPRequestOperation alloc] initWithRequest:request] autorelease];
operation.inputStream = [NSInputStream inputStreamWithFileAtPath:[[NSBundle mainBundle] pathForResource:@"large-image" ofType:@"tiff"]];
operation.outputStream = [NSOutputStream outputStreamToMemory];
[operation start];
```

## Requirements

AFNetworking requires either [iOS 5.0](http://developer.apple.com/library/ios/#releasenotes/General/WhatsNewIniPhoneOS/Articles/iPhoneOS4.html) and above, or [Mac OS 10.7](http://developer.apple.com/library/mac/#releasenotes/MacOSX/WhatsNewInOSX/Articles/MacOSX10_6.html#//apple_ref/doc/uid/TP40008898-SW7) ([64-bit with modern Cocoa runtime](https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtVersionsPlatforms.html)) and above.

## Credits

AFNetworking was created by [Scott Raymond](https://github.com/sco/) and [Mattt Thompson](https://github.com/mattt/) in the development of [Gowalla for iPhone](http://en.wikipedia.org/wiki/Gowalla).

AFNetworking's logo was designed by [Alan Defibaugh](http://www.alandefibaugh.com/).

And most of all, thanks to AFNetworking's [growing list of contributors](https://github.com/AFNetworking/AFNetworking/contributors).

## Contact

Follow AFNetworking on Twitter ([@AFNetworking](https://twitter.com/AFNetworking))

### Creators

[Mattt Thompson](http://github.com/mattt)  
[@mattt](https://twitter.com/mattt)

[Scott Raymond](http://github.com/sco)  
[@sco](https://twitter.com/sco)

## Example
AFDownloadRequestOperation *operation = [[AFDownloadRequestOperation alloc] initWithRequest:[NSURLRequest requestWithURL:url] targetPath:MUSICFile shouldResume:YES];
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"Successfully downloaded file to %@", MUSICFile);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
    
    [operation setProgressiveDownloadProgressBlock:^(NSInteger bytesRead, long long totalBytesRead, long long totalBytesExpected, long long totalBytesReadForFile, long long totalBytesExpectedToReadForFile) {
        float percentDone = totalBytesReadForFile/(float)totalBytesExpectedToReadForFile;
        
        [self.progressView setProgress:percentDone animated:YES];
        self.progressLabel.text = [NSString stringWithFormat:@"%.0f%%",percentDone*100];
        NSLog(@"------%f",percentDone);
        
        NSLog(@"Operation%i: bytesRead: %d", 1, bytesRead);
        NSLog(@"Operation%i: totalBytesRead: %lld", 1, totalBytesRead);
        NSLog(@"Operation%i: totalBytesExpected: %lld", 1, totalBytesExpected);
        NSLog(@"Operation%i: totalBytesReadForFile: %lld", 1, totalBytesReadForFile);
        NSLog(@"Operation%i: totalBytesExpectedToReadForFile: %lld", 1, totalBytesExpectedToReadForFile);
    }];
    [operation start];

## License

AFNetworking is available under the MIT license. See the LICENSE file for more info.
