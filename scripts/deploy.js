const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory(
    "WizardsGame"
  );
  const gameContract = await gameContractFactory.deploy(
    ["Hermione", "Harry", "Ron"], // Names
    [
      "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimages.ctfassets.net%2Fusf1vwtuqyxm%2F7xdaPxOL4cYmI4YusoYgKY%2F6e64803c91a26ea0069ad0fbcd7c9ace%2FHermioneGranger_WB_F6_HermioneGrangerFullbody_V2_Promo_0801615_Port.jpg%3Fw%3D1200%26fit%3Dfill%26f%3Dtop&f=1&nofb=1",
      "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fimg.ecartelera.com%2Fnoticias%2F43200%2F43218-m.jpg&f=1&nofb=1",
      "https://external-content.duckduckgo.com/iu/?u=https%3A%2F%2Fstatic.wikia.nocookie.net%2Fheroes-and-villain%2Fimages%2Fd%2Fdc%2FRon_Weasley_HPDHP2.jpg%2Frevision%2Flatest%3Fcb%3D20190316213732&f=1&nofb=1",
    ],
    [100, 200, 300], // HP values
    [100, 200, 300], // Mana values
    [100, 75, 45] // Spell damage values
  );
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);

  let txn;
  txn = await gameContract.mintCharacterNFT(0);
  await txn.wait();
  console.log("Minted NFT #1");

  txn = await gameContract.mintCharacterNFT(1);
  await txn.wait();
  console.log("Minted NFT #2");

  txn = await gameContract.mintCharacterNFT(2);
  await txn.wait();
  console.log("Minted NFT #3");

  txn = await gameContract.mintCharacterNFT(1);
  await txn.wait();
  console.log("Minted NFT #4");

  console.log("Done deploying and minting!");
};

const runMain = async () => {
  try {
    await main();
    process.exit(0);
  } catch (error) {
    console.log(error);
    process.exit(1);
  }
};

runMain();
