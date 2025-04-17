const hre = require("hardhat");

async function main() {
  const [deployer] = await hre.ethers.getSigners();
  const chainId = (await hre.ethers.provider.getNetwork()).chainId;

  console.log(`Deploying to chain ${chainId} from account: ${deployer.address}`);
  console.log("Balance:", (await deployer.getBalance()).toString());

  const zetaToken = process.env.ZETA_TOKEN;
  const connector = process.env.ZETA_CONNECTOR;

  if (!zetaToken || !connector) {
    throw new Error("ZETA_TOKEN or ZETA_CONNECTOR not defined in .env");
  }

  // Deploy DebtSettlement first
  const DebtSettlement = await hre.ethers.getContractFactory("DebtSettlement");
  const debtSettlement = await DebtSettlement.deploy(connector, zetaToken);
  await debtSettlement.deployed();
  console.log("✅ DebtSettlement deployed at:", debtSettlement.address);

  // Deploy ExpenseLogger with same connector/token
  const ExpenseLogger = await hre.ethers.getContractFactory("ExpenseLogger");
  const expenseLogger = await ExpenseLogger.deploy(connector, zetaToken);
  await expenseLogger.deployed();
  console.log("✅ ExpenseLogger deployed at:", expenseLogger.address);
}

main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});