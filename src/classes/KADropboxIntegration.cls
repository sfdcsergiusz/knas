public with sharing class KADropboxIntegration {

	public String resp { get; set; }

	public KADropboxIntegration() {
		oauthCallout();
	}

	public void oauthCallout() {
     	HttpRequest req = new HttpRequest();
     	req.setEndpoint('https://www.dropbox.com/1/oauth2/authorize?response_type=code&client_id=aoz1nyujszwkwdu');
     	req.setMethod('GET');
     	Http http = new Http();
     	HTTPResponse res = http.send(req);
     	resp = res.getBody();
   	}

}   	