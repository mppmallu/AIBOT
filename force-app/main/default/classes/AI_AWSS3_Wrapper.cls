public class AI_AWSS3_Wrapper {
    @AuraEnabled
    Public string objectKey;
    @AuraEnabled
    public Integer expirationSeconds;
    @AuraEnabled
    public String httpMethod;
    @AuraEnabled
    public String versionId;
    
    public AI_AWSS3_Wrapper(String objectKey, Integer expirationSeconds, String httpMethod, String versionId){
        this.objectKey=objectKey;
        this.expirationSeconds=expirationSeconds;
        this.httpMethod=httpMethod;
        this.versionId=versionId;
    }

}