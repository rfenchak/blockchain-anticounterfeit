import { buildModule } from "@nomicfoundation/hardhat-ignition/modules";

const ProductRegistryModule = buildModule("ProductRegistryModule", (m) => {
  const productRegistry = m.contract("ProductRegistry");
  return { productRegistry };
});

export default ProductRegistryModule;