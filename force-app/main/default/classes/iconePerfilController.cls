public with sharing class iconePerfilController {
    @AuraEnabled
    public static string uploadImg(String base64, String filename, String recordId){
        try {
            
            removeImagem(recordId);

            String imgTitle = 'imagemPerfil.'+ filename.substringAfter('.');

            ContentVersion cv = createContentVersion(base64, imgTitle);
            
            ContentDocumentLink cdl = createContentLink(cv.Id, recordId);
            
            if (cv == null || cdl == null) { 
                return null; 
            }

            return cdl.Id;
        } catch (Exception e) {
            throw new AuraHandledException(e.getMessage());
        }
    }

    @AuraEnabled
    public static void removeImagem(String idConta){
        String arquivoId;
        Account lstAccount = [SELECT Id, (SELECT Id, Title FROM CombinedAttachments WHERE Title LIKE 'imagemPerfil%') FROM Account WHERE Id =: idConta];

        for(CombinedAttachment att : lstAccount.CombinedAttachments){
            arquivoId=att.id;
        }


        List<ContentDocumentLink> ContentDocumentLinkList =[
            SELECT 
                id,
                contentdocumentid, 
                linkedentity.name,
                linkedentityid,
                linkedentity.type 
            FROM 
                ContentDocumentLink 
            WHERE 
                linkedentityid in (SELECT id FROM Account where id= :idConta)];

        List<id> DocIdList = new List<id>();

        for(ContentDocumentLink cdl: ContentDocumentLinkList){
            DocIdList.add(cdl.contentdocumentid);
        }

        List<ContentDocument> ConDocList =[SELECT Id, CreatedBy.name , ContentSize, ParentId FROM ContentDocument WHERE Id =: arquivoId];
        delete ConDocList;
    }


    @AuraEnabled
    public static String buscarImagem(String idConta){
        String arquivoId;
        Account lstAccount = [SELECT Id, (SELECT Id, Title FROM CombinedAttachments WHERE Title LIKE 'imagemPerfil%') FROM Account WHERE Id =: idConta];
        
        for(CombinedAttachment att : lstAccount.CombinedAttachments){
            arquivoId=att.id;
        }
        
        String retorno = [SELECT Id, Title FROM ContentVersion WHERE ContentDocumentId =: arquivoId limit 1].Id;
        return retorno;
    }

    private static ContentVersion createContentVersion(String base64, String filename) {
        ContentVersion cv = new ContentVersion();
        cv.VersionData = EncodingUtil.base64Decode(base64);
        cv.Title = filename;
        cv.PathOnClient = filename;
        try {
          upsert cv;
          return cv;
        } catch(DMLException e) {
          System.debug(e);
          return null;
        }
    }


    public static ContentDocumentLink createContentLink(String contentVersionId, String recordId) {
        if (contentVersionId == null || recordId == null) { 
            return null; 
        }
        ContentDocumentLink cdl = new ContentDocumentLink();
        cdl.ContentDocumentId = [
                                SELECT ContentDocumentId 
                                FROM ContentVersion 
                                WHERE Id =: contentVersionId
                                ].ContentDocumentId;
        cdl.LinkedEntityId = recordId;
        
        cdl.ShareType = 'V';
        try {
            upsert cdl;
            return cdl;
        } catch(DMLException e) {
            System.debug(e);
        return null;
        }
    }
}