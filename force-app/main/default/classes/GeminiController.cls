public with sharing class GeminiController {
    @AuraEnabled(cacheable=true)
    public static object getGeminiResponse(String inputText) {
        system.debug('MP chat input:'+inputText);
        String apiUrl = 'https://generativelanguage.googleapis.com/v1beta/models/gemini-2.0-flash:generateContent?key=' + System.Label.Gemini_API_Key;
        Http http = new Http();
        HttpRequest request = new HttpRequest();
        request.setEndpoint(apiUrl);
        request.setMethod('POST');
        request.setTimeout(120000);
        request.setHeader('Content-Type', 'application/json');

        String requestBody = '{"contents":[{"parts":[{"text":"' + inputText.escapeHtml4() + '"}]}]}';
        request.setBody(requestBody);

        try {
            HttpResponse response = http.send(request);
            if (response.getStatusCode() == 200) {
                System.debug('MPJSON==>:'+response.getBody());
                Map<String, Object> responseMap = (Map<String, Object>) JSON.deserializeUntyped(response.getBody());
                List<Object> candidates = (List<Object>) responseMap.get('candidates');
                if (!candidates.isEmpty()) {
                    Map<String, Object> firstCandidate = (Map<String, Object>) candidates[0];
                   
                     Map<String, Object> content = (Map<String, Object>)firstCandidate.get('content');
                    List<object> parts =(list<object>)content.get('parts');
                  Map<String, Object> partText = (Map<String, Object>)parts[0];
                    
                   system.debug('OutputMP:'+partText.get('text'));
                    //return (String) content.get('parts');
                    return partText.get('text');
                }
            } else {
                System.debug('API Error: ' + response.getBody());
                return 'Error: API response error. Check logs.';
            }
        } catch (Exception e) {
            System.debug('Exception: ' + e.getMessage());
            return 'Error: Unable to connect to API.';
        }
        return 'No response received.';
    }
}