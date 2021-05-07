var ProductCatalogue = artifacts.require("ProductCatalogue");

module.exports = function(deployer) {
  deployer.deploy(ProductCatalogue);
};
