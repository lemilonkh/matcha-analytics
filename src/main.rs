use matcha_analytics::startup::run;
use std::net::TcpListener;

const SERVER_URL: &str = "127.0.0.1:8000";

#[tokio::main]
async fn main() -> Result<(), std::io::Error> {
    let listener = TcpListener::bind(SERVER_URL)?;
    println!("Listening on http://{SERVER_URL}");
    run(listener)?.await
}
