declare namespace wasm_bindgen {
	/* tslint:disable */
	/* eslint-disable */
	/**
	* @param {string} s
	* @returns {string}
	*/
	export function greet(s: string): string;
	/**
	* @param {string} cairo_program
	* @param {boolean} replace_ids
	* @returns {string}
	*/
	export function compileCairoProgram(cairo_program: string, replace_ids: boolean): string;
	/**
	* @param {string} cairo_program
	* @param {number | undefined} available_gas
	* @param {boolean} print_full_memory
	* @param {boolean} use_dbg_print_hint
	* @returns {string}
	*/
	export function runCairoProgram(cairo_program: string, available_gas: number | undefined, print_full_memory: boolean, use_dbg_print_hint: boolean): string;
	
}

declare type InitInput = RequestInfo | URL | Response | BufferSource | WebAssembly.Module;

declare interface InitOutput {
  readonly memory: WebAssembly.Memory;
  readonly greet: (a: number, b: number, c: number) => void;
  readonly compileCairoProgram: (a: number, b: number, c: number, d: number) => void;
  readonly runCairoProgram: (a: number, b: number, c: number, d: number, e: number, f: number, g: number) => void;
  readonly __wbindgen_add_to_stack_pointer: (a: number) => number;
  readonly __wbindgen_malloc: (a: number, b: number) => number;
  readonly __wbindgen_realloc: (a: number, b: number, c: number, d: number) => number;
  readonly __wbindgen_free: (a: number, b: number, c: number) => void;
}

/**
* If `module_or_path` is {RequestInfo} or {URL}, makes a request and
* for everything else, calls `WebAssembly.instantiate` directly.
*
* @param {InitInput | Promise<InitInput>} module_or_path
*
* @returns {Promise<InitOutput>}
*/
declare function wasm_bindgen (module_or_path?: InitInput | Promise<InitInput>): Promise<InitOutput>;
