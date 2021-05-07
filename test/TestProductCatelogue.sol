pragma solidity ^0.5.0;
import "truffle/Assert.sol";
import "truffle/DeployedAddresses.sol";
import "../contracts/ProductCatalogue.sol";
contract TestProductCatelogue{
    ProductCatalogue pc = ProductCatalogue(DeployedAddresses.ProductCatalogue());

    uint expectedPetId = 8;
    address expectedCreator= address(this);

// Testing the CreateProduct() function with no ProductCreatorRole
     //function testCreateProductWithNoProductCreatorRole() public {
    //    uint returnedIdFromCp = pc.CreateProduct("Macbook", "Laptop");
      //  (uint256 returnedID, string memory returnedName, string memory returnedDesc, address returnedAddress, bool returnedEndorsed) = pc.QueryProduct(returnedIdFromCp);
    //    Assert.fail("No product is created matched");
    //}

    function testGrantProductCreator() public {
      pc.GrantProductCreator();
      (bool exist, bool pcr, bool per) = pc.GetRole();
      Assert.equal(pcr, true, "User has right to create product");
    }

    function testCreateProductWithProductCreatorRole() public {
        pc.GrantProductCreator();
        uint returnedIdFromCp = pc.CreateProduct("Macbook", "Laptop");
        (uint256 returnedID, string memory returnedName, string memory returnedDesc, address returnedAddress, bool returnedEndorsed) = pc.QueryProduct(returnedIdFromCp);
        Assert.equal(returnedAddress, expectedCreator, "Product creator matched");
        Assert.equal(returnedName, "Macbook", "Name of the prooduct should match");
        Assert.equal(returnedDesc, "Laptop", "description of the prooduct should match");
    }

    // Testing QueryProduct() function
    function testQueryProduct() public {
        uint returnedIdFromCp = pc.CreateProduct("Macbook Air", "Laptop");
        (uint256 returnedID, string memory returnedName, string memory returnedDesc, address returnedAddress, bool returnedEndorsed) = pc.QueryProduct(returnedIdFromCp);
        Assert.equal(returnedName, "Macbook Air", "Name of the prooduct should match");
        Assert.equal(returnedDesc, "Laptop", "description of the prooduct should match");
    }

    function testGrantProductEndorser() public {
      pc.GrantProductEndorser();
      (bool exist, bool pcr, bool per) = pc.GetRole();
      Assert.equal(per, true, "User has right to endorse product");
    }

// Testing EndorseProduct()
    function testEndorseProductWithProductEndorserRole() public {
        pc.GrantProductEndorser();
        uint returnedIdFromCp = pc.CreateProduct("Macbook Pro", "Laptop3");
        pc.EndorseProduct(returnedIdFromCp);
        uint[] memory confirmedList = pc.ShowEndorsedProduct();
        uint l = confirmedList.length;
        Assert.equal(confirmedList[l-1], returnedIdFromCp, "Product should be endorsed");
    }


}
