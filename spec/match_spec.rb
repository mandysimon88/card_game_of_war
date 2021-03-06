require 'spec_helper'

describe Match do
  let(:game) { Game.new(player1: Player.new(name: "Amanda"), player2: Player.new(name:"Vianney")) }
  let(:my_match) { Match.new(game: game, user1: User.new, user2: User.new) }

  it 'initializes with a game and two users, an array of the users, plus two players discerned from the game' do
    expect(my_match.game).to be_a Game
    expect(my_match.user1).to be_a User
    expect(my_match.user2).to be_a User
    expect(my_match.player1).to eq my_match.game.player1
    expect(my_match.player2).to eq my_match.game.player2
    expect(my_match.user1.current_match).to eq my_match
    expect(my_match.user2.current_match).to eq my_match
    expect(my_match.users).to match_array [my_match.user1, my_match.user2]
  end

  it 'upon initialization, makes the user acknowledge it as the current_match' do
    expect(my_match.user1.current_match).to eq my_match
    expect(my_match.user2.current_match).to eq my_match
  end

  it 'can give you an array of its users' do
    expect(my_match.users[0]).to eq my_match.user1
    expect(my_match.users[1]).to eq my_match.user2
  end

  it 'can tell you which player is matched to one of its users' do
    user = my_match.user1
    expect(my_match.player(user)).to eq my_match.player1
    user2 = my_match.user2
    expect(my_match.player(user2)).to eq my_match.player2
  end

  it 'can tell you which user is matched to one of its players' do
    player1 = my_match.player1
    expect(my_match.user(player1)).to eq my_match.user1
    player2 = my_match.player2
    expect(my_match.user(player2)).to eq my_match.user2
  end

  it 'can give you a json-worthy hash containing the most critical information about the objects it contains' do
    game.winner = game.player1
    game.loser = game.player2
    json_hash = {
      type: "match",
      player1: "Amanda",
      player2: "Vianney",
      player1_cards: 0,
      player2_cards: 0,
      winner: "Amanda",
      loser: "Vianney",
      rounds_played: 0
    }
    expect(my_match.to_json).to eq json_hash
  end

  it 'can end itself' do
    my_match.end_match
    expect(my_match.user1.current_match).to be nil
    expect(my_match.user2.current_match).to be nil
  end
end

describe NullMatch do
  let(:nullmatch) { NullMatch.new }
  let(:player) { NullPlayer.new }
  let(:user) { User.new }

  it 'does nothing in response to match methods' do
    expect(nullmatch.user(player)).to eq nil
    expect(nullmatch.player(user)).to eq nil
    expect(nullmatch.users).to eq []
    expect { nullmatch.to_json }.to_not raise_exception
  end

  it 'calls equal two nullmatches but not a nullmatch and a regular match' do
    expect(nullmatch == Match.new).to be false
    expect(nullmatch == NullMatch.new).to be true
  end
end
