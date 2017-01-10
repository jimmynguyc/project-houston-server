HttpClient httpclient = HttpClients.createDefault();
HttpPost httppost = new HttpPost("http://e958dea3.ngrok.io/app_state/1");

// Request parameters and other properties.
List<NameValuePair> params = new ArrayList<NameValuePair>(2);
params.add(new BasicNameValuePair("app_token", "12345678"));
httppost.setEntity(new UrlEncodedFormEntity(params, "UTF-8"));

//Execute and get the response.
HttpResponse response = httpclient.execute(httppost);
HttpEntity entity = response.getEntity();

if (entity != null) {
    InputStream instream = entity.getContent();
    try {
        // do something useful
    } finally {
        instream.close();
    }
}
