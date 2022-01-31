pragma solidity 0.5.0;

import "./data.sol";

contract Vente_materiel_centre is Data {
    
    constructor(address adresse_acheteur, address payable adresse_vendeur) public {
        vmv6 = 0x64e32eb4cE3748E1469BAE3052895f59349631F0;
        emit Deleg(vmv6);
        acheteur.partie = adresse_acheteur;
        vendeur.partie = adresse_vendeur;
        Pvendeur = adresse_vendeur;
        paiement_eth = false;
        
        contratValide = false;
        
    }
    
    function partie_est() public view returns(string memory){
        require(acheteur.partie == msg.sender || vendeur.partie == msg.sender);
        if(acheteur.partie == msg.sender){
            return "acheteur";
        }
        else{
            return "vendeur";
        }
    }
    //Lecture info :
    function read_acheteur() public view returns (string memory nom_societe, 
                                string memory forme_juridique, 
                                uint capital, 
                                string memory registre_commerce, 
                                string memory siret, 
                                string memory adresse_siege){
        require(acheteur.partie == msg.sender || vendeur.partie == msg.sender);
        return (acheteur.nom_societe, acheteur.forme_juridique, acheteur.capital, acheteur.registre_commerce, acheteur.siret, acheteur.adresse_siege);                                
    }
    function read_acheteur_representant() public view returns (string memory representant_nom,
                                string memory representant_prenom,
                                string memory representant_titre,
                                string memory representant_intitule){
        require(acheteur.partie == msg.sender || vendeur.partie == msg.sender);
        return (acheteur.representant_nom, acheteur.representant_prenom, acheteur.representant_titre,acheteur.intitule);                                
    }
    function read_vendeur() public view returns (string memory nom_societe, 
                                string memory forme_juridique, 
                                uint capital, 
                                string memory registre_commerce, 
                                string memory siret, 
                                string memory adresse_siege){
        require(acheteur.partie == msg.sender || vendeur.partie == msg.sender);
        return (vendeur.nom_societe, vendeur.forme_juridique, vendeur.capital, vendeur.registre_commerce, vendeur.siret, vendeur.adresse_siege);                                
    }
    function read_vendeur_representant() public view returns (string memory representant_nom,
                                string memory representant_prenom,
                                string memory representant_titre,
                                string memory representant_intitule){
        require(acheteur.partie == msg.sender || vendeur.partie == msg.sender);
        return (vendeur.representant_nom, vendeur.representant_prenom, vendeur.representant_titre, vendeur.intitule); 
    }
    
    
    function Materiel_lire() public view returns (string memory,string memory,string memory,string memory){
        require(acheteur.partie == msg.sender || vendeur.partie == msg.sender);
        return (materiel.marque,materiel.numero_de_serie,materiel.description,materiel.description_objet_supp);
    }

    
    function Vente_lire() public view returns (string memory,string memory,string memory,string memory,string memory,string memory,string memory){
        require (acheteur.partie == msg.sender || vendeur.partie == msg.sender);
        if(vente.virement)
    	    return ("virement",vente.prix_ht,vente.prix_tva,"",vente.virement_date_de_paiment,vente.virement_num_compte,vente.virement_nom_banc);
    	 else if(vente.cheque){
    	     return ("cheque",vente.prix_ht,vente.prix_tva,vente.cheque_numero,"","","");
    	 }
    	 else if(vente.espece){
    	     return ("espece",vente.prix_ht,vente.prix_tva,"","","","");
    	 }
    	 else if(vente.eth){
    	     return ("eth",vente.prix_ht,vente.prix_tva,"","","","");
    	 }
    	 
    }
    
    function Prix_eth() public view returns(uint){
        require (acheteur.partie == msg.sender || vendeur.partie == msg.sender);
        return vente.eth_prix;
    }
    
    function Etat_bien_lire() public view returns (string memory){
        require(acheteur.partie ==msg.sender || vendeur.partie == msg.sender);
        return etat_bien.etat;
    }

    function Livraison_lire() public view returns (string memory,string memory,string memory){
        require(acheteur.partie == msg.sender || vendeur.partie == msg.sender);
        if(livraison.retire_vendeur)
    	    return ("retirer chez le vendeur",livraison.adresse,livraison.date_livraison);
        else if(livraison.livre_vendeur)
    	    return ("livrer par le vendeur",livraison.adresse,livraison.date_livraison);
        else if(livraison.livre_frais_acheteur)
    	    return("livraison aux frais de l'acheteur",livraison.adresse,livraison.date_livraison);
    }
    
    function Garanties_lire() public view returns(string memory,string memory){
        require(acheteur.partie == msg.sender || vendeur.partie == msg.sender);
        if(garanties.pas_de_garanties)
            return ("pas de garanties", "0");
        if(garanties.cession_garanties)
            return("cession de garanties", garanties.dure);
        if(garanties.garanties_vendeur)
            return("garanties_vendeur", garanties.dure);
    }
    
    function Litige_signature_lire() public view returns (string memory,string memory,string memory,string memory){
        require(acheteur.partie == msg.sender || vendeur.partie == msg.sender);
    	if(litige_signature.signature_vendeur && litige_signature.signature_acheteur)
    	    return("signer par le vendeur et l'acheteur", litige_signature.nom_tribunal,litige_signature.ville_signature,litige_signature.date_signature);
    	else if(litige_signature.signature_acheteur)
    	    return("signer que par l'acheteur", litige_signature.nom_tribunal,litige_signature.ville_signature,litige_signature.date_signature);
    	else if(litige_signature.signature_vendeur)
    	    return("signer que par le vendeur", litige_signature.nom_tribunal,litige_signature.ville_signature,litige_signature.date_signature);
    	else
    	    return("aucune signature", litige_signature.nom_tribunal,litige_signature.ville_signature,litige_signature.date_signature);
    }
    
    function Contract_valide() public view returns(bool){
        require(acheteur.partie == msg.sender || vendeur.partie == msg.sender);
        return contratValide;
    }
    function Paiement_OK() public view returns(bool){
        require(acheteur.partie == msg.sender || vendeur.partie == msg.sender);
        return paiement_eth;
    }
    
    function updateinfo(string memory inf) public{
        bool t;
        //Vente_materiel_V6 vmv6 = Vente_materiel_V6(0x388a2aF47242c565ec1C5a899557d0c98bDa1A09);
        
        (t,) = vmv6.delegatecall(abi.encodeWithSignature("updateinfo(string)",inf));
        //(t,) = vmv6.delegatecall(abi.encodeWithSignature("updateinfo(bytes)",inf2));
        require(t);
    }
    function payer() public payable{
        bool t;
        //Vente_materiel_V6 vmv6 = Vente_materiel_V6(0x388a2aF47242c565ec1C5a899557d0c98bDa1A09);
        (t,) = vmv6.delegatecall(abi.encodeWithSignature("payer()"));
        require(t);
    }
    function lu() public { 
        bool t;
        (t,) = vmv6.delegatecall(abi.encodeWithSignature("lu()"));
        require(t);
    }
    function signature() public{
         bool t;
        (t,) = vmv6.delegatecall(abi.encodeWithSignature("signature()"));
        require(t);
    }
}