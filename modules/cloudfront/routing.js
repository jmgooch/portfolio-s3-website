function handler(event) {
    var request = event.request;
    var uri = request.uri;

    // Only intervene if the user is hitting the root of the site
    if (uri === '/' || uri === '/index.html') {
        var headers = request.headers;
        var language = 'en'; // Default to English

        // Check if the browser sent an Accept-Language header
        if (headers['accept-language']) {
            var acceptLang = headers['accept-language'].value.toLowerCase();
            // Check for Japanese language codes (ja or ja-JP)
            if (acceptLang.includes('ja')) {
                language = 'jp';
            }
        }

        // Rewrite the internal URI to fetch the correct S3 folder
        request.uri = '/' + language + '/index.html';
    }

    return request;
}