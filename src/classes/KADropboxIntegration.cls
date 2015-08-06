public with sharing class KADropboxIntegration {

	public String appKey { get; set; }
    public String appSecret { get; set; }
    public String dropboxCode { get; set; }
    public String resp { get; set; }

	public KADropboxIntegration() {
        appKey = 'aoz1nyujszwkwdu';
        appSecret = '5ml8z7pmiqp21sl';        
	}

	public PageReference getDropboxLink() {
        return new PageReference('https://www.dropbox.com/1/oauth2/authorize?response_type=code&client_id=' + appKey);
   	}

    public void getDropboxToken() {
        HttpRequest req = new HttpRequest();
        req.setEndpoint('https://api.dropbox.com/1/oauth2/token?code=' + dropboxCode + 
            '&grant_type=authorization_code&client_id=' + appKey + '&client_secret=' + appSecret);
        req.setMethod('POST');
        //req.setHeader('authorize', 'bare');

        HTTPResponse res = new Http().send(req);
        resp = res.getBody();
    }
    
}