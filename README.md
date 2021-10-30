# Index contract

Create an index contract.
Index is the ERC-20 token. It has weights and assets.
Example: Index contains asset A with weight 50%, asset B with weight 25% and asset C with weight 25%.

You need to implement mint and burn logic for Index. For that you need to use UniswapV2's methods for swapping from base token (token which you charge during mint) to Index’s tokens. After burning the recipient should receive tokens which the Index consists of.

Try running some of the following tasks:

```shell
npx hardhat accounts
npx hardhat compile
npx hardhat clean
npx hardhat test
npx hardhat node
node scripts/sample-script.js
npx hardhat help
```
