require 'rails_helper'

RSpec.describe Ristoratore, type: :model do
  # Step 1: Creazione di due utenti
  let(:utente1) { Utente.create!(email: "utente1@test.com", telefono: "1234567890", password: "Password", password_confirmation: "Password") }
  let(:utente2) { Utente.create!(email: "utente2@test.com", telefono: "0987654321", password: "Password", password_confirmation: "Password") }

  # Step 2: Associazione di ciascun utente a un cliente
  let(:cliente1) { Cliente.create!(utente: utente1) }
  let(:cliente2) { Cliente.create!(utente: utente2) }

  # Step 3: Creazione di uno user e di un ristoratore a partire dai clienti
  let(:user) { User.create!(cliente: cliente1, username: "username", nome:"nome", cognome: "cognome") }
  let(:ristoratore) { Ristoratore.create!(cliente: cliente2, piva: "12345678901", nomeristorante: "Ristorante Test", indirizzo: "Via Test 123", asporto: true) }

  let(:tag) { Tag.create!(nome: "Italiano") }

  context "when creating a ristoratore" do
    it "saves the required attributes correctly" do
      expect(ristoratore.piva).to eq("12345678901")
      expect(ristoratore.nomeristorante).to eq("Ristorante Test")
      expect(ristoratore.indirizzo).to eq("Via Test 123")
      expect(ristoratore.asporto).to be(true)
    end
  end

  context "when associating reviews" do
    let!(:recensione1) { ristoratore.recensiones.create!(cliente: cliente1, stelle: 5, commento: "Ottimo ristorante") }
    let!(:recensione2) { ristoratore.recensiones.create!(cliente: cliente1, stelle: 3, commento: "Buono") }

    it "associates reviews correctly" do
      expect(ristoratore.recensiones).to include(recensione1, recensione2)
    end

    it "calculates the correct number of reviews" do
      expect(ristoratore.n_recensioni).to eq(2)
    end

    it "calculates the correct average rating" do
      expect(ristoratore.media_stelle).to eq(4.0)
    end
  end

  context "when associating tags" do
    it "associates tags correctly" do
      choose = ristoratore.chooses.create!(tag: tag)
      expect(ristoratore.tags).to include(tag)
    end
  end

  context "when verifying associations" do
    let!(:recensione) { ristoratore.recensiones.create!(cliente: cliente1, stelle: 5, commento: "Ottimo ristorante") }

    before do
      ristoratore.chooses.create!(tag: tag)
    end

    it "has associated tags" do
      expect(ristoratore.tags).to include(tag)
    end

    it "has associated reviews" do
      expect(ristoratore.recensiones).to include(recensione)
    end
  end
end
