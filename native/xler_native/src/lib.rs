#[macro_use] extern crate rustler;
extern crate rustler_codegen;
extern crate lazy_static;
extern crate calamine;

use rustler::{Env, NifResult, Encoder, Term, SchedulerFlags};
use calamine::{Reader, open_workbook_auto};
use calamine::Error as CaError;

mod atoms {
    rustler_atoms! {
        atom ok;
        atom error;

        // Posix
        atom enoent; // File does not exist
        atom eacces; // Permission denied
        atom epipe;  // Broken pipe
        atom eexist; // File exists
    }
}

rustler_export_nifs! {
    "Elixir.Xler.Native",
    [
        ("parse", 2, parse, SchedulerFlags::DirtyCpu),
        ("worksheets", 1, worksheets, SchedulerFlags::DirtyCpu)
    ],
    None
}

fn io_error_to_term<'a>(env: Env<'a>, err: &CaError) -> Term<'a> {
    let error = match err {
        _ => format!("{}", err).encode(env),
    };

    (atoms::error(), error).encode(env)
}

fn worksheets<'a>(env: Env<'a>, args: &[Term<'a>]) -> NifResult<Term<'a>> {
    let filename: String = args[0].decode()?;

    match open_workbook_auto(&filename) {
        Err(ref error) => return Ok(io_error_to_term(env, error)),
        Ok(ref inner) => Ok((atoms::ok(), inner.sheet_names().to_owned()).encode(env)),
    }
}


fn parse<'a>(env: Env<'a>, args: &[Term<'a>]) -> NifResult<Term<'a>> {
    let filename: String = try!(args[0].decode());
    let sheetname: String = try!(args[1].decode());

    let mut excel = match open_workbook_auto(&filename) {
        Err(ref error) => return Ok(io_error_to_term(env, error)),
        Ok(inner) => inner,
    };

    if let Some(Ok(range)) = excel.worksheet_range(&sheetname) {
        let row: Vec<(Vec<String>)> = range
                        .rows()
                        .into_iter()
                        .enumerate()
                        .map(|(_i, col)| 
                            col
                            .iter()
                            .map(|c|
                                c.to_string()
                            )
                            .collect::<Vec<_>>()
                        )
                        .collect::<Vec<_>>();
        
        Ok((atoms::ok(), row.encode(env)).encode(env))
    } else {
        Ok((atoms::error(), "Couldnt find the worksheet").encode(env))
    }
}