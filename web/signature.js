const d_information = document.querySelector('.Send_information');
const valide_Contrat= document.querySelector('.Valide_Contrat');
const lu_Contrat= document.querySelector('.Lu_Contrat');
const paiement= document.querySelector('.Paiement');


var nom_tribunal = document.getElementById("nom_tribunal");
var ville_signature = document.getElementById("ville_signature");
var date_signature = document.getElementById("date_signature");

var ANS = document.getElementById('ANS');
var AFJ = document.getElementById('AFJ');
var AC = document.getElementById('AC');
var ARC = document.getElementById('ARC');
var AS = document.getElementById('AS');
var AAS = document.getElementById('AAS');
var nom_r = document.getElementById('nom_r');
var prenom_r = document.getElementById('prenom_r');
var titre_r = document.getElementById('titre_r');
var intiule1 = document.getElementById('rMadame');
var intiule2 = document.getElementById('rMonsieur');

var marque = document.getElementById('marque');
var numero_de_serie = document.getElementById('numero_de_serie');
var description = document.getElementById('description');
var description_objet_supplementaire = document.getElementById('description_objet_supplementaire');

var prix_ht = document.getElementById('prix_ht');
var prix_tva = document.getElementById('prix_tva');
var prix_eth = document.getElementById('prix_eth');
var virement_num_compte = document.getElementById('virement_num_compte');
var virement_nom_banc = document.getElementById('virement_nom_banc');

var type = document.getElementById('type');
var cheque_numero = document.getElementById('cheque_numero');
var virement_date_de_paiment = document.getElementById('virement_date_de_paiment');

var ou = document.getElementById('ou');
var adresse = document.getElementById('adresse');
var date_livraison = document.getElementById('date_livraison');

var typeg = document.getElementById('typeg');
var dure = document.getElementById('dure');

var etat = document.getElementById('etat');

var nom_tribunal = document.getElementById('nom_tribunal');
var ville_signature = document.getElementById('ville_signature');
var date_signature = document.getElementById('date_signature');

d_information.addEventListener('click', () => {
    envoi_information()
});

valide_Contrat.addEventListener('click', () => {
    Valide_Contrat()
});

lu_Contrat.addEventListener('click', () => {
    Lu_Contrat()
});

paiement.addEventListener('click', () => {
   Paiement()
});


function envoi_information() {
    getAccount();
    $("#txLitige_signature").text("Informations en cours d'envoi ...");

    var c = false;//type
    var e = false;
    var v = false;
    var eth = false;
    
    var rv = false;//ou
    var lv = false;
    var lfa = false;

    var pg = false;//typeg
    var cg = false;
    var gv = false;

    var intitule = "";
    
    if(intiule1.checked){
	intitule = "Madame";

    }else if(intiule2.checked){
	intitule = "Monsieur";
    }

    
    //livraison
    if(ou.value == "retire_vendeur"){
	rv = true;
    }
    else if(ou.value == "livre_vendeur"){
	lv = true;
    }
    else if(ou.value ==  "livre_frais_acheteur"){
	lfa = true;
    }
    //garanties
    if(typeg.value == "pas_de_garanties"){
	pg = true;
    }
    else if(typeg.value == "cession_garanties"){
	cg = true;
    }
    else if(typeg.value ==  "garanties_vendeur"){
	gv = true;
    }
    //Vente
    if(type.value == "cheque"){
	c = true;
    }
    else if(type.value == "espece"){
	e = true;
    }
    else if(type.value ==  "virement"){
	v = true;
    }
    else if(type.value ==  "eth"){
	eth = true;
    }

    var prix_Wei = web3.toWei(prix_eth.value, "ether")

    var message = ANS.value+','+AFJ.value+','+AC.value+','+ARC.value+','+AS.value+','+AAS.value+','+nom_r.value+','+prenom_r.value+','+titre_r.value+','+intitule+','+marque.value+','+numero_de_serie.value+','+description.value+','+description_objet_supplementaire.value+','+prix_ht.value+','+prix_tva.value+','+prix_Wei+','+v+','+e+','+c+','+eth+','+cheque_numero.value+','+virement_date_de_paiment.value+','+virement_num_compte.value+','+virement_nom_banc.value+','+rv+','+lv+','+lfa+','+adresse.value+','+date_livraison.value+','+pg+','+cg+','+gv+','+dure.value+','+etat.value+','+nom_tribunal.value+','+ville_signature.value+','+date_signature.value+',';

    console.log(message);
    
    VM.methods.updateinfo(message)
        .send({ from: account })
	.on("receipt", function(receipt) {
	    $("#txLitige_signature").text("Informations envoyé avec succès!");
	    init_affiche_contrat();
	    affiche_contrat();
	    //affich_litige_signature();
        })
        .on("error", function(error) {
	    $("#txLitige_signature").text(error);
        });
    
    
}

function Lu_Contrat(){
    getAccount();
    $("#Validation_Litige_signature").text("Envoi contrat lu ...");

    VM.methods.lu()
	.send({ from: account})
	.on("receipt", function(receipt) {
	    init_affiche_contrat();
	    affiche_contrat();
	    $("#Validation_Litige_signature").text("Contrat lu envoyé");
	})
	.on("error", function(error) {
	    $("#Validation_Litige_signature").text(error);
	});
}

function Valide_Contrat(){
    getAccount();
    $("#Validation_Litige_signature").text("Envoi validation litige_signature ...");

    VM.methods.signature()
	.send({ from: account})
	.on("receipt", function(receipt) {
	    init_affiche_contrat();
	    affiche_contrat();
	})
	.on("error", function(error) {
	    $("#Validation_Litige_signature").text(error);
	});
}
function Paiement(){
    getAccount();
    $("#Validation_Litige_signature").text("Envoi paiement ...");
    VM.methods.Contract_valide().call({from: account}).then((result) => {
	if(result == true){
	    VM.methods.Prix_eth().call({ from: account }).then((tmp) => {
		VM.methods.payer()
		    .send({ from: account,value:web3.toWei(tmp.toString(), "wei") })
		    .on("receipt", function(receipt) {
			init_affiche_contrat();
			affiche_contrat();
		    })
		    .on("error", function(error) {
			$("#Validation_Litige_signature").text(error);
		    });
	    });
	}
	else{
	    $("#Validation_Litige_signature").text("Le contrat doit être signé avant");
	}
    }).catch(function(err){
	console.log('err...\n'+err);
    });
    
}


function affiche_contrat(){
    
    VM.methods.read_acheteur().call({ from: account }).then((result) => {
	VM.methods.read_acheteur_representant().call({ from: account }).then((result2) => {
	    $("#affiche_acheteur").append("<p align='justify'>La société "+result.nom_societe+", "+result.forme_juridique+" au capital de "+result.capital+" euros, immatriculée au registre du commerce et des sociétés de "+result.registre_commerce+" sous le numéro "+result.siret+", dont le siège est à "+result.adresse_siege+",<br/>représentée par "+result2.representant_intitule+" "+result2.representant_nom+" "+result2.representant_prenom+" en sa qualité de "+result2.representant_titre+",</p><br/>");

	}).catch(function(err){
            console.log('err...\n'+err);
	});
        
    }).catch(function(err){
        console.log('err...\n'+err);
    });
    VM.methods.read_vendeur().call({ from: account }).then((result) => {
	VM.methods.read_vendeur_representant().call({ from: account }).then((result2) => {
	     	$("#affiche_vendeur").append("<p align='justify'>La société "+result.nom_societe+", "+result.forme_juridique+" au capital de "+result.capital+" euros, immatriculée au registre du commerce et des sociétés de "+result.registre_commerce+" sous le numéro "+result.siret+", dont le siège est à "+result.adresse_siege+",<br/>représentée par "+result2.representant_intitule+" "+result2.representant_nom+" "+result2.representant_prenom+" en sa qualité de "+result2.representant_titre+",</p><br/>");
	    
	}).catch(function(err){
            console.log('err...\n'+err);
	});

	
    }).catch(function(err){
        console.log('err...\n'+err);
    });

    VM.methods.Materiel_lire().call({ from: account }).then((result) => {
	$("#affiche_materiel").append("<p align='justify'> Le vendeur vend à l’acheteur un matériel de de marque "+result[0]+", numéros de série "+result[1]+" avec les caractéristiques suivantes: </p><br/>\
	      <br/>\
	      "+result[2]+"<br/>\
		<br/>\
		L’objet de la vente comprend également "+result[3]+"<br/>");
    }).catch(function(err){
        console.log('err...\n'+err);
    });   
    
    var tmp;
    VM.methods.Prix_eth().call({ from: account }).then((result) => {
	tmp = result/1000000000000000000;
    });
    VM.methods.Vente_lire().call({ from: account }).then((result) => {
	if(result[0] == "virement"){
	    $("#affiche_vente").append("Les parties s’entendent sur un prix de vente "+result[1]+" euros HT auquel s’ajoute le montant de la TVA (20,6 %), soit un prix TTC de : "+result[2]+" euro.<br/>\
Le règlement doit être versé au plus tard le "+result[4]+" par virement sur le compte n°"+result[5]+" auprès de "+result[6]+".<br/>");
	}
	if(result[0] == "cheque"){
	    $("#affiche_vente").append("<p align='justify'>Les parties s’entendent sur un prix de vente "+result[1]+" euros HT auquel s’ajoute le montant de la TVA (20,6 %), soit un prix TTC de: "+result[2]+" euro.<br/>\
Le matériel est payable comptant à réception du bien par chèque n°"+result[3]+".</p><br/>");
	}
	if(result[0] == "espece"){
	    $("#affiche_vente").append("<p align='justify'>Les parties s’entendent sur un prix de vente "+result[1]+" euros HT auquel s’ajoute le montant de la TVA (20,6 %), soit un prix TTC de: "+result[2]+" euro.<br/>\
Le matériel est payable comptant à réception du bien en espèces.</p><br/>");
	}
	if(result[0] == "eth"){
	    $("#affiche_vente").append("<p align='justify'>Les parties s’entendent sur un prix de vente "+result[1]+" euros HT auquel s’ajoute le montant de la TVA (20,6 %), soit un prix TTC de: "+result[2]+" euro.<br/>\
Le matériel est payable comptant à réception du bien en ether: "+tmp+"eth</p>");
	}
    }).catch(function(err){
        console.log('err...\n'+err);
    });

    
    VM.methods.Livraison_lire().call({ from: account }).then((result) => {
	if(result[0] == 'retirer chez le vendeur'){
	    $("#affiche_livraison").append("<p align='justify'>Le matériel sera retiré chez le vendeur à "+result[1]+" par l’acheteur le "+result[2]+" à ses frais.</p><br/>");
	}
	else if(result[0] == 'livrer par le vendeur'){
	    $("#affiche_livraison").append("<p align='justify'>Le matériel sera livré chez l’acheteur à "+result[1]+" par le vendeur le "+result[2]+" à ses frais.</p><br/>");
	}
	else if(result[0] == "livraison aux frais de l'acheteur"){
	    $("#affiche_livraison").append("<p align='justify'>Le matériel sera livré chez l’acheteur, aux frais de ce dernier, à "+result[1]+" par le vendeur le "+result[2]+".</p><br/>");
	}
	
    }).catch(function(err){
        console.log('err...\n'+err);
    });

    VM.methods.Etat_bien_lire().call({ from: account }).then((result) => {
	$("#affiche_etat_bien").append("<p align='justify'>L’acheteur déclare connaître le bien pour l’avoir bien examiné et essayé.l’état du matériel industriel est le suivant: "+result+"\
<br/>\
Toutes les détériorations constatées sur le matériel après la livraison seront à la charge de l’acheteur.</p><br/>");
    }).catch(function(err){
        console.log('err...\n'+err);
    });

    VM.methods.Garanties_lire().call({ from: account }).then((result) => {
	if(result[0] == 'pas de garanties'){
	    $("#affiche_Garanties").append("<p align='justify'>Toute garantie par le vendeur est catégoriquement exclue contractuellement.</p><br/>");
	}
	else if(result[0] == 'cession de garanties'){
	    $("#affiche_Garanties").append("<p align='justify'>Le vendeur cède une garantie légale ou constructeur du matériel industriel d’une durée de "+result[1]+".</p><br/>");
	}
	else if(result[0] == 'garanties_vendeur'){
	    $("#affiche_Garanties").append("<p align='justify'>Le vendeur accorde à l’acheteur un droit à la réparation pour une période de  "+result[1]+".</p><br/>");
	}
    }).catch(function(err){
        console.log('err...\n'+err);
    });

    VM.methods.Litige_signature_lire().call({ from: account }).then((result) => {
	$("#affiche_litige_signature").append("<p align='justify'>Les parties conviennent expressément que tout litige pouvant naître de l’exécution du présent contrat relèvera de la compétence du tribunal "+result[1]+".</p><br/>\
Fait à "+result[2]+", le "+result[3]+"<br/>");
	
    }).catch(function(err){
        console.log('err...\n'+err);
    });

    VM.methods.Contract_valide().call({from: account}).then((result) => {
	if(result == true){
	    $("#Validation_Litige_signature").text("Contrat signé");
	}
	else{
	    $("#Validation_Litige_signature").text("Contrat non signé ");
	}
    }).catch(function(err){
	console.log('err...\n'+err);
    });

    VM.methods.Paiement_OK().call({from: account}).then((result) => {
	if(result == true){
	    $("#Paiement").text("Contrat payé");
	}
	else{
	    $("#Paiement").text("Contrat non payé ");
	}
    }).catch(function(err){
	console.log('err...\n'+err);
    });
}

