const main = async () => {
  const gameContractFactory = await hre.ethers.getContractFactory(
    "WizardsGame"
  );
  const gameContract = await gameContractFactory.deploy(
    ["Hermione", "Harry", "Ron"],
    [
      "QmTwdjy3fCdzRtyuoaVzyHfq59Hyrazs768gqTrCjLDPj2",
      "QmTKLFNTdTmFNiz3iSg847qXWMNPKG89HPqbYuDzJESRkd",
      "QmRmjY2uBEpN8DHS6hKohojNbBM73Z7qiwJ7LwoFidnxmu",
    ],
    [100, 200, 300],
    [100, 200, 300],
    [100, 75, 45],
    "Voldemort",
    "Qmdqgo9eAMJ2LuDMdibEEN4jkQUz6gRA9YSKGDLriovnrt",
    10000,
    40
  );
  await gameContract.deployed();
  console.log("Contract deployed to:", gameContract.address);
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
