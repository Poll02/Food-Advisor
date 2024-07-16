require 'rails_helper'
require 'faker'

RSpec.describe RicercaController, type: :controller do
  describe "GET #index" do
    before do
      # Creazione dei due utenti utilizzando Faker
      @utente1 = Utente.create!(email: Faker::Internet.email, telefono: Faker::PhoneNumber.phone_number, password: "Password1", password_confirmation: "Password1")
      @utente2 = Utente.create!(email: Faker::Internet.email, telefono: Faker::PhoneNumber.phone_number, password: "Password2", password_confirmation: "Password2")
      @utente3 = Utente.create!(email: Faker::Internet.email, telefono: Faker::PhoneNumber.phone_number, password: "Password3", password_confirmation: "Password3")
      @utente4 = Utente.create!(email: Faker::Internet.email, telefono: Faker::PhoneNumber.phone_number, password: "Password4", password_confirmation: "Password4")

      # Creazione dei due clienti associati ai due utenti
      @cliente1 = Cliente.create!(utente: @utente1)
      @cliente2 = Cliente.create!(utente: @utente2)
      @cliente3 = Cliente.create!(utente: @utente3)
      @cliente4 = Cliente.create!(utente: @utente4)

      # Creazione dei due ristoratori associati ai due clienti
      @ristoratore1 = Ristoratore.create!(nomeristorante: Faker::Restaurant.name, asporto: true, cliente: @cliente1, piva: Faker::Company.ein, indirizzo: Faker::Address.full_address)
      @ristoratore2 = Ristoratore.create!(nomeristorante: Faker::Restaurant.name, asporto: false, cliente: @cliente2, piva: Faker::Company.ein, indirizzo: Faker::Address.full_address)

      @recensione1 = Recensione.create!(ristoratore: @ristoratore1, cliente: @cliente3, stelle: 4, commento: Faker::Restaurant.review.truncate(400))
      @recensione2 = Recensione.create!(ristoratore: @ristoratore1, cliente: @cliente3, stelle: 5, commento: Faker::Restaurant.review.truncate(400))
      @recensione3 = Recensione.create!(ristoratore: @ristoratore2, cliente: @cliente4, stelle: 3, commento: Faker::Restaurant.review.truncate(400))

      @tag1 = Tag.create!(nome: Faker::Restaurant.type, categoria: Faker::Commerce.department)
      @tag2 = Tag.create!(nome: Faker::Restaurant.type, categoria: Faker::Commerce.department)

      # Associamo i tag ai ristoratori
      @ristoratore1.tags << @tag1
      @ristoratore1.tags << @tag2

    end

    it "returns http success" do
      get :index
      expect(response).to have_http_status(:success)
    end

    it "assigns @ristoratori with all ristoratori when no filters are applied" do
      get :index
      expect(assigns(:ristoratori)).to contain_exactly(@ristoratore1, @ristoratore2)
    end

    it "filters ristoratori by name when query parameter is present" do
      get :index, params: { query: @ristoratore1.nomeristorante.split(' ').first } # Filtra per parte del nome
      expect(assigns(:ristoratori)).to match_array([@ristoratore1])
    end

    it "filters ristoratori by minimum and maximum reviews" do
      get :index, params: { min_reviews: 2, max_reviews: 3 }
      expect(assigns(:ristoratori)).to match_array([@ristoratore1])
    end

    it "filters ristoratori by asporto option" do
      get :index, params: { asporto: "1" }
      expect(assigns(:ristoratori)).to match_array([@ristoratore1])
    end

    it "filters ristoratori by tags" do
      get :index, params: { tags: [@tag1.id, @tag2.id] }
      expect(assigns(:ristoratori)).to match_array([@ristoratore1])
    end

    it "filters ristoratori by star rating" do
      get :index, params: { star_rating: 4 }
      expect(assigns(:ristoratori)).to match_array([@ristoratore1])
    end

    it "limits the number of ristoratori to 10 by default" do
      # Creiamo 15 ristoratori, ciascuno con un utente e un cliente associato
      15.times do
        utente = Utente.create!(
          email: Faker::Internet.email,
          telefono: Faker::PhoneNumber.phone_number,
          password: "Passwordd",
          password_confirmation: "Passwordd"
        )

        cliente = Cliente.create!(utente: utente)

        Ristoratore.create!(
          nomeristorante: Faker::Restaurant.name,
          asporto: [true, false].sample,
          cliente: cliente,
          piva: Faker::Company.ein,
          indirizzo: Faker::Address.full_address
        )
      end

      get :index
      expect(assigns(:ristoratori).count).to eq(10)
    end

  end
end
