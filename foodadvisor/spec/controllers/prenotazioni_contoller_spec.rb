require 'rails_helper'

RSpec.describe PrenotazioneController, type: :controller do
  let(:utente1) { Utente.create!(email: "utente1@test.com", telefono: "1234567890", password: "Password", password_confirmation: "Password") }
  let(:utente2) { Utente.create!(email: "utente2@test.com", telefono: "0987654321", password: "Password", password_confirmation: "Password") }

  let(:cliente1) { Cliente.create!(utente: utente1) }
  let(:cliente2) { Cliente.create!(utente: utente2) }

  let(:user) { User.create!(cliente: cliente1, username: "username", nome:"nome", cognome: "cognome") }
  let(:ristoratore) { Ristoratore.create!(cliente: cliente2, piva: "12345678901", nomeristorante: "Ristorante Test", indirizzo: "Via Test 123", asporto: true) }

  let(:prenotazione) { Prenotazione.create!(user: user, ristoratore: ristoratore, numero_persone: 4, data: Date.tomorrow, orario: '19:00') }

  before do
    allow(controller).to receive(:current_user).and_return(utente1)
    allow(controller).to receive(:logged_in?).and_return(true)
    session[:role] = 'User'
    session[:user_id] = utente1.id # Assicurati di impostare l'ID utente nella sessione
  end

  describe "POST #create" do
    context "when user is logged in as 'User'" do
      it "creates a new prenotazione" do
        expect {
          post :create, params: {
            prenotazione: {
              numero_persone: 4,
              data: Date.tomorrow,
              orario: '19:00',
              ristoratore_id: ristoratore.id,
              user_id: user.id
            }
          }
        }.to change(Prenotazione, :count).by(1)
        
        
        expect(Prenotazione.last.user_id).to eq(user.id)
        expect(Prenotazione.last.valida).to eq(false)
      end
    end

    context "when user is not logged in as 'User'" do
      before do
        allow(controller).to receive(:session).and_return({ role: 'Admin' })
      end

      it "does not create a new prenotazione" do
        expect {
          post :create, params: {
            prenotazione: {
              numero_persone: 4,
              data: Date.tomorrow,
              orario: '19:00',
              ristoratore_id: ristoratore.id
            }
          }
        }.to_not change(Prenotazione, :count)
        
      end
    end
  end

  describe "PATCH #set_valida" do
    before do
      prenotazione.valida = false
      prenotazione.save!
    end

    it "sets prenotazione as valid and adds points to user competitions" do
      patch :set_valida, params: { id: prenotazione.id }
      prenotazione.reload
      expect(prenotazione.valida).to eq(true)
      # Add expectations to check if points were added correctly
    end
  end

  describe "DELETE #destroy" do
    it "deletes the prenotazione" do
      prenotazione # create prenotazione
      expect {
        delete :destroy, params: { id: prenotazione.id }
      }.to change(Prenotazione, :count).by(-1)
    end
  end
end