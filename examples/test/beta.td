import "json"
import "crypto"

type player struct {
	name string
	uid string
	created time
	health int
	point int
}

type game struct {
	players map
}

fn (g game) add_player(p) {
	g.players[p.uid] = p
}

fn (g game) remove_player(uid) {
	delete(g.players, uid)
}

game_ := game{
	players: {}
}

p1 := player{
	name: "Katagiri_",
	uid: crypto.random.uuid(),
	created: time()
}

game_.add_player(p1)
// game_.remove_player(p1.uid)

debug <| game_
// game_ |> json.encode |> string |> debug