slint::include_modules!();

fn main() -> Result<(), slint::PlatformError> {
    let ui = AppWindow::new()?;

    // let ui_handle = ui.as_weak();
    // ui.on_request_counter_add(move |amount: i32| {
    //     let ui = ui_handle.unwrap();
    //     ui.set_counter(ui.get_counter() + amount);
    // });

    ui.run()
}
