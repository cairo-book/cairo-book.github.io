use colored::Colorize;
use regex::Regex;
use std::collections::HashSet;
use walkdir::WalkDir;

pub fn find_cairo_files(path: &str) -> Vec<String> {
    let mut cairo_files: Vec<String> = Vec::new();

    for entry in WalkDir::new(path).into_iter().filter_map(|e| e.ok()) {
        if let Some(file_name) = entry.file_name().to_str() {
            if file_name.ends_with(".cairo") {
                cairo_files.push(entry.path().display().to_string());
            }
        }
    }

    cairo_files
}

/// Will replace the file path contained in the input string with a clickable format for better output
pub fn clickable(input: &str) -> String {
    let mut path_parts: Vec<&str> = input.split(|c: char| c == '\\' || c == '/').collect();

    let mut filename: String = path_parts.last().unwrap_or(&"").to_string();
    let re = Regex::new(r"([^:]+(:\d+:\d+)?)(:\s|$)").unwrap();
    if let Some(captures) = re.captures(filename.as_str()) {
        filename = captures.get(1).map_or("", |m| m.as_str()).to_string();
    }

    path_parts.last_mut().map(|s| *s = &filename);
    let full_path = path_parts.join("/");

    let clickable_format = format!(
        "\u{1b}]8;;{}\u{1b}\\{}\u{1b}]8;;\u{1b}\\",
        full_path, filename
    )
    .bold()
    .red()
    .to_string();

    input.replacen(&full_path, &clickable_format, 1)
}

pub fn print_error_table(errors: &HashSet<String>, section_name: &str) {
    if errors.is_empty() {
        return;
    }

    println!("{}", format!("{}: {}", section_name, errors.len()).bold().on_red());

    for error in errors {
        println!(" - {}", error);
    }

    println!("");
}
