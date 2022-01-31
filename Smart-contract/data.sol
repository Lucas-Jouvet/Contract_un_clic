ragma solidity 0.5.0;


contract Data {
    event Deleg(address deleg);
    event Signature(string message);
    event Validation(string message);
    event Paiement(string message);
    struct Partie{
        address partie;
        string nom_societe;
        string forme_juridique;
        uint capital;
        string registre_commerce;
        string siret;
        string adresse_siege;
        string representant_nom;
        string representant_prenom;
        string representant_titre;
        string intitule;
    }
    address payable Pvendeur;
    Partie acheteur;
    Partie vendeur;
    
    struct Materiel{
        string marque;
        string numero_de_serie;
        string description;
        string description_objet_supp;
    }

    Materiel materiel;
    
    struct Vente{
        string prix_ht;
        string prix_tva;
        uint eth_prix;
        bool virement;
        bool espece;
        bool cheque;
        bool eth;
        string cheque_numero;
        string virement_date_de_paiment;
        string virement_num_compte;
        string virement_nom_banc;
           
    }
    Vente vente;
    
    struct Livraison{
        bool retire_vendeur;
        bool livre_vendeur;
        bool livre_frais_acheteur;
        string adresse;
        string date_livraison;
    }
    Livraison livraison;
    
    struct Garanties{
        bool pas_de_garanties;
        bool cession_garanties;
        bool garanties_vendeur;
        string dure;
    }
    Garanties garanties;
    
    struct Etat_Bien{
        string etat;
    }
    Etat_Bien etat_bien;
    
      struct Litige_signature{
        string nom_tribunal;
        string ville_signature;
        string date_signature;
        bool lu_vendeur;
        bool lu_acheteur;
        bool signature_vendeur;
        bool signature_acheteur;
    }
    Litige_signature litige_signature;
    
    bool contratValide;
    bool paiement_eth;
    
     address vmv6;

}