pragma solidity ^0.5.0;

contract ProductCatalogue {
    struct product {
        uint256 ProductID;
        string name;
        string description;
        address creator;
        bool endorsed;
    }

    struct role {
      bool exist;
      bool ProductCreator;
      bool ProductEndorser;
    }
    mapping(uint256 => product) public catalogue; // map of productID to the product details
    uint256[] private unconfirmedList;  // the list of IDs of the non-endorsed products
    uint256[] private confirmedList;    // the list of ID of the endorsed products
    uint256 public curPID = 0;
    address owner;  //owner of this smart contract

    mapping(address => role) public RoleMap;


    // you will need to introduce additional data structures and functions for Part II.

    constructor() public {
        owner = msg.sender;
        curPID = 0;
    }

    function GrantProductCreator() public {
      if (RoleMap[msg.sender].exist){
          RoleMap[msg.sender].ProductCreator = true;
      } else {
        role memory r = role({exist: true, ProductCreator: true, ProductEndorser: false});
        RoleMap[msg.sender] = r;
      }
    }

    function GrantProductEndorser() public {
      if (RoleMap[msg.sender].exist){
          RoleMap[msg.sender].ProductEndorser = true;
      } else {
        role memory r = role({exist: true, ProductCreator: false, ProductEndorser: true});
        RoleMap[msg.sender] = r;
      }
    }



    function GetRole() public view returns (bool, bool, bool){
      if (RoleMap[msg.sender].exist){
          return ( true, RoleMap[msg.sender].ProductCreator, RoleMap[msg.sender].ProductEndorser);
      } else {
          return (false, false, false);
      }
    }

    function CreateProduct(string memory name, string memory description)
        public
        returns (uint256) // returns the productID of the newly created product
    {
        //For part I, anynoe can call this function to create a new product
        //For part II, only users with the role of creator can create products

        if (RoleMap[msg.sender].exist){
          if (RoleMap[msg.sender].ProductCreator){
            product memory p = product({ProductID: curPID, name: name, description: description, creator: msg.sender, endorsed: false});
            catalogue[curPID] = p;
            unconfirmedList.push(curPID);
            curPID += 1;
            return (curPID-1);
          }
        }

        revert("Product is not created; No ProductCreator role is found");
    }

    function EndorseProduct(uint256 pid) public {
        // The input is the product ID to be endorsed
        // For part I, anyone can call this function
        // For part II, only users with the role of endorser can endorse products



        if (RoleMap[msg.sender].exist){
          if (RoleMap[msg.sender].ProductEndorser){
            product memory p = catalogue[pid];
            p.endorsed = true;

            uint256 endorsedIndex = locate(pid);
            removeData(endorsedIndex);
            confirmedList.push(pid);
          } else {
            revert("No product is endorsed ; No ProductEndorser role is found");
          }
        } else {
                      revert("No product is endorsed ; No ProductEndorser role is found");
        }


    }

    function ShowEndorsedProduct() public view returns (uint256[] memory) {
        return confirmedList;   // no need to change this function
    }

    function ShowNonEndorsedProduct() public view returns (uint256[] memory) {
        return unconfirmedList; // no need to change this function
    }

    function QueryProduct(uint256 pid)
        public
        view
        returns (
            uint256,
            string memory,
            string memory,
            address,
            bool
        )
    {
        // on input a product ID, returns the details of this product.
        if (catalogue[pid].creator > address(0)){
          product memory p = catalogue[pid];
          return (pid, p.name, p.description, p.creator, p.endorsed);
        } else {
          revert("No product with this product ID");
        }

    }

    function locate(uint256 pid) private view returns (uint256) {   //helper function, find of index of the productID in the list of non-endorsed products. no need to change this function
        uint256 index = curPID;
        for (uint256 i = 0; i < unconfirmedList.length; i++) {
            if (unconfirmedList[i] == pid) index = i;
        }
        return index;
    }

    function removeData(uint256 index) private {    //helper function, remove an element from the list of non-endorsed product. Use when the product is endorsed. no need to change this function
        unconfirmedList[index] = unconfirmedList[unconfirmedList.length - 1];
        unconfirmedList.pop();
    }

}
