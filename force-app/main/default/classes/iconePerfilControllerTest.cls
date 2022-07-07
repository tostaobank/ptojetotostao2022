@isTest
public class iconePerfilControllerTest {
    @isTest
    public static void createContentLinkTest() {
        Account objConta = new Account();
        objConta.Name = 'Roberto';
        insert objConta;
        
        ContentVersion contentVersion = new ContentVersion(
        Title     = 'imagemPerfil.jpg',
        PathOnClient = 'imagemPerfil.jpg',
        VersionData  = Blob.valueOf('Test Content'),
        IsMajorVersion = true);
        insert contentVersion;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = objConta.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        cdl.visibility = 'AllUsers';
        insert cdl;
        
        Test.startTest();
        iconePerfilController.createContentLink(contentVersion.Id, objConta.Id);
        Test.stopTest();
    }

    @isTest
    public static void createContentLinkTestNull() {
        
        Test.startTest();
        iconePerfilController.createContentLink(null, null);
        Test.stopTest();
    }

    @isTest
    public static void removeImagemTest() {
        Account objConta = new Account();
        objConta.Name = 'Roberto';
        insert objConta;

        ContentVersion contentVersion = new ContentVersion(
        Title     = 'imagemPerfil.jpg',
        PathOnClient = 'imagemPerfil.jpg',
        VersionData  = Blob.valueOf('Test Content'),
        IsMajorVersion = true);
        insert contentVersion;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = objConta.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        cdl.visibility = 'AllUsers';
        insert cdl;

        Test.startTest();
        iconePerfilController.removeImagem(objConta.Id);
        Test.stopTest();
    }

    @isTest
    public static void buscarImagemTest() {
        Account objConta = new Account();
        objConta.Name = 'Roberto';
        insert objConta;

        ContentVersion contentVersion = new ContentVersion(
        Title     = 'imagemPerfil.jpg',
        PathOnClient = 'imagemPerfil.jpg',
        VersionData  = Blob.valueOf('Test Content'),
        IsMajorVersion = true);
        insert contentVersion;

        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
        //create ContentDocumentLink record
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = objConta.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        cdl.visibility = 'AllUsers';
        insert cdl;

        Test.startTest();
        iconePerfilController.buscarImagem(objConta.Id);
        Test.stopTest();
    }

    @isTest
    public static void uploadImgTest() {
        Account objConta = new Account();
        objConta.Name = 'Roberto';
        insert objConta;
        
        ContentVersion contentVersion = new ContentVersion(
        Title     = 'imagemPerfil.jpg',
        PathOnClient = 'imagemPerfil.jpg',
        VersionData  = Blob.valueOf('Test Content'),
        IsMajorVersion = true);
        insert contentVersion;
        
        List<ContentDocument> documents = [SELECT Id, Title, LatestPublishedVersionId FROM ContentDocument];
    
        ContentDocumentLink cdl = New ContentDocumentLink();
        cdl.LinkedEntityId = objConta.id;
        cdl.ContentDocumentId = documents[0].Id;
        cdl.shareType = 'V';
        cdl.visibility = 'AllUsers';
        insert cdl;
        
        Test.startTest();
        String retorno = iconePerfilController.uploadImg('pao com batata',contentVersion.Id, objConta.Id);
        Test.stopTest();

    

        System.assertNotEquals(retorno, cdl.Id);
    }
}