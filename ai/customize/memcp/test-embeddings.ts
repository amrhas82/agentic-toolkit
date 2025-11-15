/**
 * Test script to verify embedding generation
 * Validates that embeddings are generated correctly with 384 dimensions
 * Run with: npx tsx test-embeddings.ts
 */

import { LocalEmbeddings } from "./src/embeddings/LocalEmbeddings.js";

async function testEmbeddings() {
  console.log("🧪 Testing embedding generation...\n");

  try {
    // Initialize embedding provider
    console.log("1️⃣ Initializing LocalEmbeddings...");
    const embeddings = new LocalEmbeddings("Xenova/all-MiniLM-L6-v2");
    await embeddings.initialize();
    console.log("✓ LocalEmbeddings initialized\n");

    // Test 1: Generate embedding for simple text
    console.log("2️⃣ Test 1: Generating embedding for simple text...");
    const text1 = "This is a test memory about database configuration";
    const embedding1 = await embeddings.generateEmbedding(text1);
    console.log(`   Text: "${text1}"`);
    console.log(`   Embedding dimension: ${embedding1.length}`);
    console.log(`   First 5 values: [${embedding1.slice(0, 5).map(v => v.toFixed(4)).join(", ")}]`);

    if (embedding1.length !== 384) {
      throw new Error(`Expected 384 dimensions, got ${embedding1.length}`);
    }
    console.log("   ✓ Dimension is correct (384)\n");

    // Test 2: Generate embedding for different text
    console.log("3️⃣ Test 2: Generating embedding for different text...");
    const text2 = "Nginx SSL configuration for staging environment";
    const embedding2 = await embeddings.generateEmbedding(text2);
    console.log(`   Text: "${text2}"`);
    console.log(`   Embedding dimension: ${embedding2.length}`);
    console.log(`   First 5 values: [${embedding2.slice(0, 5).map(v => v.toFixed(4)).join(", ")}]`);

    if (embedding2.length !== 384) {
      throw new Error(`Expected 384 dimensions, got ${embedding2.length}`);
    }
    console.log("   ✓ Dimension is correct (384)\n");

    // Test 3: Verify embeddings are different
    console.log("4️⃣ Test 3: Verifying embeddings are different...");
    let differences = 0;
    for (let i = 0; i < embedding1.length; i++) {
      if (Math.abs(embedding1[i]! - embedding2[i]!) > 0.0001) {
        differences++;
      }
    }
    console.log(`   Differences found: ${differences} / ${embedding1.length} values`);

    if (differences === 0) {
      throw new Error("Embeddings are identical for different texts!");
    }
    console.log("   ✓ Embeddings are different (as expected)\n");

    // Test 4: Verify normalization (unit vector)
    console.log("5️⃣ Test 4: Verifying normalization (unit vector)...");
    let magnitude = 0;
    for (let i = 0; i < embedding1.length; i++) {
      magnitude += embedding1[i]! * embedding1[i]!;
    }
    magnitude = Math.sqrt(magnitude);
    console.log(`   Magnitude: ${magnitude.toFixed(6)}`);

    // Should be close to 1.0 (normalized vector)
    if (Math.abs(magnitude - 1.0) > 0.01) {
      throw new Error(`Expected normalized vector (magnitude ~1.0), got ${magnitude}`);
    }
    console.log("   ✓ Vector is normalized (magnitude ≈ 1.0)\n");

    // Test 5: Verify all values are numbers
    console.log("6️⃣ Test 5: Verifying all values are valid numbers...");
    const invalidValues = embedding1.filter(v => !Number.isFinite(v));
    console.log(`   Invalid values found: ${invalidValues.length}`);

    if (invalidValues.length > 0) {
      throw new Error(`Found ${invalidValues.length} invalid values (NaN or Infinity)`);
    }
    console.log("   ✓ All values are valid numbers\n");

    // Cleanup
    console.log("7️⃣ Cleaning up resources...");
    await embeddings.cleanup();
    console.log("✓ Resources cleaned up\n");

    // Success summary
    console.log("═══════════════════════════════════════");
    console.log("✅ ALL TESTS PASSED!");
    console.log("═══════════════════════════════════════");
    console.log("✓ Embedding generation works correctly");
    console.log("✓ Dimension is 384 as expected");
    console.log("✓ Different texts produce different embeddings");
    console.log("✓ Vectors are normalized (unit vectors)");
    console.log("✓ All values are valid numbers");
    console.log("═══════════════════════════════════════\n");

  } catch (error) {
    console.error("\n❌ TEST FAILED:");
    console.error(error instanceof Error ? error.message : String(error));
    process.exit(1);
  }
}

// Run tests
testEmbeddings().catch((error) => {
  console.error("Fatal error:", error);
  process.exit(1);
});
