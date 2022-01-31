pragma solidity 0.5.0;

import "./data.sol";

contract Vente_materiel_V6 is Data {
    
    //fonction appeler pour modifier des informations dans les structures
    function updateinfo(string memory inf1) public{
        require(msg.sender == acheteur.partie || msg.sender == vendeur.partie);
        require(contratValide == false);
        bytes memory inf = bytes(inf1);
        
        uint pos = 0; //position dans inf
        int i;
        string memory tmp; //stockage temporaire retour fonction
        
        Partie storage p = vendeur;
        if(msg.sender == acheteur.partie){
            p = acheteur;
        }
        
        (pos, tmp) = parseString(pos,inf); // retourne l'informations de la position de pos à la prochaine virgule. pos est mis à jour tmp possède l'info
        if(bytes(tmp).length != 0) p.nom_societe = tmp; // si tmp n'est pas vide p.nom_societe prend la valeur de tmp
        (pos, tmp) = parseString(pos,inf);
        if(bytes(tmp).length != 0) p.forme_juridique = tmp;
        (pos, tmp) = parseString(pos,inf);
        if(bytes(tmp).length != 0) p.capital = parseInt(tmp);
        (pos, tmp) = parseString(pos,inf);
        if(bytes(tmp).length != 0) p.registre_commerce = tmp;
        (pos, tmp) = parseString(pos,inf);
        if(bytes(tmp).length != 0) p.siret = tmp;
        (pos, tmp) = parseString(pos,inf);
        if(bytes(tmp).length != 0) p.adresse_siege = tmp;
        (pos, tmp) = parseString(pos,inf);
        if(bytes(tmp).length != 0) p.representant_nom = tmp;
        (pos, tmp) = parseString(pos,inf);
        if(bytes(tmp).length != 0) p.representant_prenom = tmp;
        (pos, tmp) = parseString(pos,inf);
        if(bytes(tmp).length != 0) p.representant_titre = tmp;
        (pos, tmp) = parseString(pos,inf);
        if(bytes(tmp).length != 0) p.intitule = tmp;
        
 
        if(msg.sender == vendeur.partie){ // Les informations suivante ne peuvent être fourni que par le vendeur.
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) materiel.marque = tmp;
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) materiel.numero_de_serie = tmp;
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) materiel.description = tmp;
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) materiel.description_objet_supp = tmp;
        
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) vente.prix_ht = tmp;
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0)vente.prix_tva = tmp;
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) vente.eth_prix = parseInt(tmp);
        }
        else{
            for(i = 0; i < 7;i++){
                (pos, tmp) = parseString(pos,inf);
            }
        }
        if(msg.sender == acheteur.partie){
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) vente.virement = parseBool(tmp);
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) vente.espece = parseBool(tmp);
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) vente.cheque = parseBool(tmp);
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0)vente.eth = parseBool(tmp);
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) vente.cheque_numero = tmp;
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) vente.virement_date_de_paiment = tmp;
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) vente.virement_num_compte = tmp;
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) vente.virement_nom_banc = tmp;
        }
        else{
            for(i = 0; i < 8;i++){
                (pos, tmp) = parseString(pos,inf);
            }
        }
        
        if(msg.sender == vendeur.partie){
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) livraison.retire_vendeur= parseBool(tmp);
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) livraison.livre_vendeur = parseBool(tmp);
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) livraison.livre_frais_acheteur = parseBool(tmp);
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) livraison.adresse = tmp;
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) livraison.date_livraison = tmp;
        }
        else{
            for(i = 0; i < 5;i++){
                (pos, tmp) = parseString(pos,inf);
            }
        }
        suite(inf,pos); // limitation dimantion de la fonction impose de créer une fonction prenant la suite.

    }
    
    function suite(bytes memory inf,  uint pos) internal{
        string memory tmp;
        int i;
        if(msg.sender == vendeur.partie){
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) garanties.pas_de_garanties = parseBool(tmp);
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) garanties.cession_garanties = parseBool(tmp);
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) garanties.garanties_vendeur = parseBool(tmp);
            (pos, tmp) = parseString(pos,inf);
            if(bytes(tmp).length != 0) garanties.dure = tmp;
        }
        else{
            for(i = 0; i < 4;i++){
                (pos, tmp) = parseString(pos,inf);
            }
        }
        (pos, tmp) = parseString(pos,inf);
        if(bytes(tmp).length != 0) etat_bien.etat = tmp;
        
        (pos, tmp) = parseString(pos,inf);
        if(bytes(tmp).length != 0) litige_signature.nom_tribunal = tmp;
        (pos, tmp) = parseString(pos,inf);
        if(bytes(tmp).length != 0) litige_signature.ville_signature = tmp;
        (pos, tmp) = parseString(pos,inf);
        if(bytes(tmp).length != 0) litige_signature.date_signature = tmp;
    }
    
    function lu() public { // fonction permettant à l'acheteur et au vendeur de confirmer qu'ils ont chacun bien lu les informations
        require(msg.sender == acheteur.partie || msg.sender == vendeur.partie);
        if(msg.sender == acheteur.partie){
            litige_signature.lu_acheteur = true;
            emit Signature("Acheteur lu");
        }
        else{
            litige_signature.lu_vendeur = true;
            emit Signature("Vendeur lu");
        }
    }
    function signature() public{ //Signature du contrat
        require(msg.sender == acheteur.partie || msg.sender == vendeur.partie);
        Partie storage p = vendeur;
        if(msg.sender == acheteur.partie){
            p = acheteur;
        }
        //Vérification que les informations obligatoire sont bien fourni
        require(bytes(p.nom_societe).length != 0);
        require(bytes(p.forme_juridique).length != 0);
        require(bytes(p.registre_commerce).length != 0);
        require(bytes(p.siret).length != 0);
        require(bytes(p.adresse_siege).length != 0);
        require(bytes(p.representant_nom).length != 0);
        require(bytes(p.representant_prenom).length != 0);
        require(bytes(p.representant_titre).length != 0);
        
        require(bytes(materiel.marque).length != 0);
        require(bytes(materiel.numero_de_serie).length != 0);
        require(bytes(materiel.description).length != 0);
        
        require(bytes(vente.prix_ht).length != 0);
        require(bytes(vente.prix_tva).length != 0);
        
        require(bytes(livraison.adresse).length != 0);
        require(bytes(livraison.date_livraison).length != 0);
        
        require(garanties.pas_de_garanties || garanties.cession_garanties || garanties.garanties_vendeur);
        
        require(bytes(etat_bien.etat).length != 0);
        
        require(bytes(litige_signature.nom_tribunal).length != 0);
        require(bytes(litige_signature.ville_signature).length != 0);
        require(bytes(litige_signature.date_signature).length != 0);
        
        if(msg.sender == acheteur.partie){
            require(litige_signature.lu_acheteur);
            litige_signature.signature_acheteur = true;
            emit Signature("Acheteur signé");
        }
        else{
            require(litige_signature.lu_vendeur);
            litige_signature.signature_vendeur = true;
            emit Signature("Vendeur signé");
        }
        if(litige_signature.signature_acheteur && litige_signature.signature_vendeur){
            contratValide = true;
            if(vente.eth){
                emit Validation("Contrat signé par les partis paiement eth demandé.");
            }
            else{
               emit Validation("Contrat signé par les partis pas de paiement eth demandé."); 
            }
        }
    }
    function payer() public payable{ //Fonction permettant le paiement en ether
        require(acheteur.partie == msg.sender && msg.value == vente.eth_prix && contratValide == true && vente.eth);
        Pvendeur.transfer(msg.value);
        paiement_eth = true;
        emit Paiement("Transaction Ether effectué.");
    }
    
    function parseString(uint pos,bytes memory s) internal pure returns (uint,string memory) { // permet de récupérer les élement à partir de la position "pos"  jusqu'à la virgule suivante.
        uint i;
        uint end;
        for(i = pos; i < s.length; i++){
            if(s[i] == ','){
                end = i;
                break;
            }
        }
        bytes memory result = new bytes(end-pos);
        for (i = pos; i<end; i++) {
            result[i-pos] = s[i];
        }
        end++;
        return (end,string(result));
    }
    
    
    
    function parseBool(string memory _a) internal pure returns (bool) { // Sting to bool
        if (strCompare(_a, 'true') == 0) {
            return true;
        } else {
            return false;
        }
    }
    
    // String compare
    function strCompare(string memory _a, string memory _b) internal pure returns (int) {
        bytes memory a = bytes(_a);
        bytes memory b = bytes(_b);
        uint minLength = a.length;
        if (b.length < minLength) minLength = b.length;
        for (uint i = 0; i < minLength; i ++)
            if (a[i] < b[i])
                return -1;
            else if (a[i] > b[i])
                return 1;
        if (a.length < b.length)
            return -1;
        else if (a.length > b.length)
            return 1;
        else
            return 0;
    }
    function parseInt(string memory _a) internal pure returns (uint) { // string to int
        bytes memory bresult = bytes(_a);
        uint mint = 0;
        for (uint i=0; i<bresult.length; i++){
            if ((uint8(bresult[i]) >= 48) && (uint8(bresult[i]) <= 57)) {
                mint *= 10;
                mint += uint8(bresult[i]) - 48;
            }
        }
        return mint;
    }
    
}