importScripts("../pkg/wasm-cairo.js")
const { greet, compileCairoProgram, runCairoProgram } = wasm_bindgen;

(async () => {
    await wasm_bindgen("../pkg/wasm-cairo_bg.wasm")

    console.log(greet("Wasm-cairo ready."))
})();

onmessage = function (e) {
    const { data, functionToRun } = e.data;
    wasm_bindgen("../pkg/wasm-cairo_bg.wasm").then(() => {
        let result;
        switch (functionToRun) {
            case "runCairoProgram":
                const { availableGas, printFullMemory, useDBGPrintHint } = e.data;
                result = runCairoProgram(data, availableGas, printFullMemory, useDBGPrintHint);
                break;
            case "compileCairoProgram":
                const { replaceIds } = e.data;
                result = compileCairoProgram(data, replaceIds);
                break;
            default:
                console.error(`Unexpected function: ${functionToRun}`);
                return;
        }
        postMessage(result);
    });
}
