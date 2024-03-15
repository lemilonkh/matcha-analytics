use matcha_analytics::{
    configuration::get_configuration,
    startup::run,
    telemetry::{get_subscriber, init_subscriber},
};
use sqlx::PgPool;
use std::net::TcpListener;

#[tokio::main]
async fn main() -> Result<(), std::io::Error> {
    // logging setup with tracing
    let subscriber = get_subscriber("matcha_analytics".into(), "info".into(), std::io::stdout);
    init_subscriber(subscriber);

    let configuration = get_configuration().expect("Failed to read configuration");
    let connection_pool = PgPool::connect_lazy_with(configuration.database.with_db());
    let address = &format!(
        "{}:{}",
        configuration.application.host, configuration.application.port
    );
    let listener = TcpListener::bind(address)?;
    println!("Listening on http://{address}");
    run(listener, connection_pool)?.await
}
