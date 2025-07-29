-include .env

# cast wallet import your_account_name --interactive

deployF:
	forge script scripts/DeployDiamondScript.sol:DiamondUpgradeScript \
  --rpc-url ${RPC_URL} \
  --broadcast \
  --sig "deployMainDiamond()" \
	--verify \
	--etherscan-api-key ${ETHERSCAN_API_KEY} \
	--verifier etherscan \
	--verifier-url "https://api-sepolia.basescan.org/api" \
	--account your_account_name \
	--sender your_address 

deployLisk:
	forge script scripts/DeployDiamondScript.sol:DiamondUpgradeScript \
	--rpc-url https://rpc.api.lisk.com \
	--etherscan-api-key 123 \
	--broadcast \
  --sig "deployMainDiamond()" \
	--verify \
	--verifier blockscout \
	--verifier-url https://blockscout.lisk.com/api \
	--account your_account_name \
	--sender your_address 
