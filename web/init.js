var account;
var Vente_Materiel_address;
const new_contract = document.querySelector('.new_contract');
const go = document.querySelector('.go');

var add = document.getElementById("add");
var na = document.getElementById("na");
var nv = document.getElementById("nv");

var intervalId = null;
var debut = false;
var init = false;
var affiche_contrat_time = 0;

function startApp() {
    document.getElementById("formulaire").style.display = "none";
    document.getElementById("Contrat").style.display = "none";
    Vente_Materiel_address = "0x6c674915487e23E373569205550be188B979f171";
    VM = new web3js.eth.Contract(VMABI, Vente_Materiel_address);
    getAccount();
    console.log("compte : "+account);
    intervalId = setInterval(getAccount, 2000);
}

new_contract.addEventListener('click', () => {
    new_Contract();
});

go.addEventListener('click', () => {
    VM = new web3js.eth.Contract(VMABI, add.value);
    init = true;
    debut = true;
    document.getElementById("formulaire").style.display = "block";
    document.getElementById("Contrat").style.display = "block";
    document.getElementById("div_init").style.display = "none";
    getAccount();
});
async function new_Contract(){

    accounts = await ethereum.enable();
    add.value = "Déploiement en cours";
    const deployedContract = await new web3js.eth.Contract(abiv5)
	  .deploy({
	      data: compile,
	      arguments: [na.value, nv.value]
	  })
	  .send({
	      from: accounts[0]
	  });

    console.log(
	`Contract deployed at address: ${deployedContract.options.address}`
    );
    add.value = deployedContract.options.address;

    VM = new web3js.eth.Contract(VMABI, add.value);
    init = true;
    debut = true;
    document.getElementById("formulaire").style.display = "block";
    document.getElementById("Contrat").style.display = "block";
    document.getElementById("div_init").style.display = "none";
    
    
}
var tmp;
function affiche(){
   
    document.getElementById("Partie").innerHTML = tmp;
    if(tmp == "acheteur"){
	document.getElementById("div_materiel").style.display = "none";
	document.getElementById("div_vente_vendeur").style.display = "none";
	document.getElementById("div_livraison").style.display = "none";
	document.getElementById("div_garanties").style.display = "none";
	document.getElementById("div_vente_acheteur").style.display = "block";
    }
    else{
	document.getElementById("div_materiel").style.display = "block";
	document.getElementById("div_vente_vendeur").style.display = "block";
	document.getElementById("div_livraison").style.display = "block";
	document.getElementById("div_garanties").style.display = "block";
	document.getElementById("div_vente_acheteur").style.display = "none";
    }
}
function init_affiche_contrat(){
    $("#etherscan").empty();
    $("#etherscan").append("<a href='https://ropsten.etherscan.io/address/"+add.value+"'>Etherscan : "+add.value+"</a>");
    $("#affiche_vendeur").empty();
    $("#affiche_acheteur").empty();
    $("#affiche_materiel").empty();
    $("#affiche_vente").empty();
    $("#affiche_livraison").empty();
    $("#affiche_etat_bien").empty();
    $("#affiche_Garanties").empty();
    $("#affiche_litige_signature").empty();
    $("#Validation_Litige_signature").empty();
    $("#Paiement").empty();
}


async function getAccount() {
    const accounts = await ethereum.enable();
    var oldaccount = account;
    account = accounts[0];
    if((oldaccount != account || debut == true || affiche_contrat_time == 60) && init == true){
	debut = false;
	VM.methods.partie_est().call({ from: account }).then((result) => {
	    tmp = result;
	    affiche();
	    init_affiche_contrat();
	    affiche_contrat();
	});
	
    }
    affiche_contrat_time = affiche_contrat_time+2;
    
}
window.addEventListener('load', function() {
    if (typeof ethereum !== 'undefined') {
	ethereum.enable()
	    .catch(console.error)
	web3js = new Web3(window['ethereum']);
    }
    else {
	alert("Vous devez installer metamask et vous connecter au réseau ropsten : https://metamask.io/")
    }

    startApp()

});
