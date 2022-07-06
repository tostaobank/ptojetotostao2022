import { LightningElement, api } from 'lwc';
import imgPadrao from '@salesforce/resourceUrl/logo';
import uploadImg from '@salesforce/apex/iconePerfilController.uploadImg';
import buscarImagem from '@salesforce/apex/iconePerfilController.buscarImagem';
import removeImagem from '@salesforce/apex/iconePerfilController.removeImagem';

export default class IconePerfil extends LightningElement {
    @api recordId;
    img = imgPadrao;
    fileData;
    acc;
    i;
    btn;

    mostarUpload(){

        if(this.template.querySelector('div').style.display == 'block'){
            this.template.querySelector('div').style.display = 'none';
        }else{
            this.template.querySelector('div').style.display = 'block';
        }
    }


    connectedCallback(){
        this.buscar(this.recordId);
    }


    openfileUpload(event) {
        const file = event.target.files[0]
        var reader = new FileReader()
        reader.onload = () => {
            var base64 = reader.result.split(',')[1]
            this.textTeste=file.name;
            this.fileData = {
                'filename': file.name,
                'base64': base64,
                'recordId': this.recordId
            }
            console.log(this.fileData)
        }
        reader.readAsDataURL(file)
    }


    
    addImg(){
        const {base64, filename, recordId} = this.fileData
        
        
        uploadImg({ base64, filename, recordId }).then(result=>{
            this.fileData = null
            let title = `${filename} uploaded successfully!!`
        })
        
        Location.reload(false);
    }
    
    removeImg(){

        removeImagem({ idConta }).then(result =>{
            alert('FUNCIONOU '+ result);
        }).catch(err => {
            alert('f....' + err.message);
            console.log("erro interno =-=-=-=-=-=-=-=-=-=-:"+err);
        })
        this.img = imgPadrao;
    }

    buscar(idConta){
        
        buscarImagem({idConta}).then(result => {
            this.img = "https://tostobank-dev-ed.file.force.com/sfc/servlet.shepherd/version/renditionDownload?rendition=ORIGINAL_Png&versionId="+result;
            console.log("resultado interno =-=-=-=-=-=-=-=-=-=-:"+result);
        }).catch(err => {
            console.log("erro interno =-=-=-=-=-=-=-=-=-=-:"+err);
        })
    }
    atualizarTela(){
        eval("%A.get('e.force:refreshView').fire()");
    } 
}