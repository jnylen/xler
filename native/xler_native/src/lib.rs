#[macro_use]
extern crate rustler;
extern crate calamine;
extern crate lazy_static;

use calamine::Error as CaError;
use calamine::{open_workbook_auto, Reader};
use rustler::{Encoder, Env, Term};

mod atoms {
    atoms! {
        ok,
        error,
    }
}

fn io_error_to_term<'a>(env: Env<'a>, err: &CaError) -> Term<'a> {
    let error = match err {
        _ => format!("{}", err).encode(env),
    };

    (atoms::error(), error).encode(env)
}

#[nif(schedule = "DirtyCpu")]
fn worksheets<'a>(env: Env<'a>, filename: String) -> Term<'a> {

    match open_workbook_auto(&filename) {
        Err(ref error) => return io_error_to_term(env, error),
        Ok(ref inner) => (atoms::ok(), inner.sheet_names().to_owned()).encode(env),
    }
}

#[nif(schedule = "DirtyCpu")]
fn parse<'a>(env: Env<'a>, filename: String, sheetname: String) -> Term<'a> {
    let mut excel = match open_workbook_auto(&filename) {
        Err(ref error) => return io_error_to_term(env, error),
        Ok(inner) => inner,
    };


    if let Some(Ok(range)) = excel.worksheet_range(&sheetname) {
        let rows: Vec<Vec<String>> = range
            .rows()
            .into_iter()
            .enumerate()
            .map(|(_i, col)| col.iter().map(|c| c.to_string()).collect::<Vec<_>>())
            .collect::<Vec<_>>();

        (atoms::ok(), rows).encode(env)
    } else {
        (atoms::error(), "Couldnt find the worksheet").encode(env)
    }
}

rustler::init!("Elixir.Xler.Native", [worksheets, parse]);
