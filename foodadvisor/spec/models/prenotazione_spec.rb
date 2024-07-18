require 'rails_helper'

RSpec.describe Prenotazione, type: :model do
  let(:utente1) { Utente.create!(email: "utente1@test.com", telefono: "1234567890", password: "Password", password_confirmation: "Password") }
  let(:utente2) { Utente.create!(email: "utente2@test.com", telefono: "0987654321", password: "Password", password_confirmation: "Password") }

  let(:cliente1) { Cliente.create!(utente: utente1) }
  let(:cliente2) { Cliente.create!(utente: utente2) }

  let(:user) { User.create!(cliente: cliente1, username: "username", nome: "nome", cognome: "cognome") }
  let(:ristoratore) { Ristoratore.create!(cliente: cliente2, piva: "12345678901", nomeristorante: "Ristorante Test", indirizzo: "Via Test 123", asporto: true) }

  let(:prenotazione) { Prenotazione.new(user_id: user.id, ristoratore_id: ristoratore.id, numero_persone: 4, data: Date.tomorrow, orario: Time.parse('14:00')) }

  describe "validations" do
    it "is valid with valid attributes" do
      expect(prenotazione).to be_valid
    end

    it "is not valid without numero_persone" do
      prenotazione.numero_persone = nil
      prenotazione.validate
      expect(prenotazione.errors[:numero_persone]).to include("non può essere vuoto")
    end

    it "is not valid with numero_persone less than 1" do
      prenotazione.numero_persone = 0
      prenotazione.validate
      expect(prenotazione.errors[:numero_persone]).to include("deve essere compreso tra 1 e 20")
    end

    it "is not valid with numero_persone greater than 20" do
      prenotazione.numero_persone = 21
      prenotazione.validate
      expect(prenotazione.errors[:numero_persone]).to include("deve essere compreso tra 1 e 20")
    end

    it "is not valid without data" do
      prenotazione.data = nil
      prenotazione.validate
      expect(prenotazione.errors[:data]).to include("non può essere vuoto")
    end

    it "is not valid with data in the past" do
      prenotazione.data = Date.yesterday
      prenotazione.validate
      expect(prenotazione.errors[:data]).to include("deve essere maggiore o uguale alla data odierna")
    end

    it "is not valid without orario" do
      prenotazione.orario = nil
      prenotazione.validate
      expect(prenotazione.errors[:orario]).to include("non può essere vuoto")
    end
  end

  describe "associations" do
    it "belongs to a user" do
      expect(prenotazione.user_id).to eq(user.id)
    end

    it "belongs to a ristoratore" do
      expect(prenotazione.ristoratore_id).to eq(ristoratore.id)
    end

    it "can be accessed through user" do
      prenotazione.save!
      expect(user.prenotaziones).to include(prenotazione)
    end

    it "can be accessed through ristoratore" do
      prenotazione.save!
      expect(ristoratore.prenotaziones).to include(prenotazione)
    end
  end
end