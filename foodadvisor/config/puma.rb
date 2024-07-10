# config/puma.rb

# Configurazione predefinita per Puma. Puoi adattarla alle tue necessità.

max_threads_count = ENV.fetch("RAILS_MAX_THREADS") { 5 }
min_threads_count = ENV.fetch("RAILS_MIN_THREADS") { max_threads_count }
threads min_threads_count, max_threads_count

#port ENV.fetch("PORT") { 3000 }

environment ENV.fetch("RAILS_ENV") { "development" }

pidfile ENV.fetch("PIDFILE") { "tmp/pids/server.pid" }

# Aggiungi il supporto SSL
ssl_bind '0.0.0.0', '3000', {
  key: "config/ssl/server.key",
  cert: "config/ssl/server.crt",
  verify_mode: "none"
}

plugin :tmp_restart
