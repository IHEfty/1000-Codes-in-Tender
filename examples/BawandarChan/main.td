import "canvas"
import "image"
import "times"
import "os"
import "path"
import "fs"
import "strings"
import "math"
import "helper/randint"

var w = 500
var h = 300

// Sprite and dialogue data
var current_sprite = "sprite/1.png"
var current_dialogue = "UwU! I'm Bawandar-chan! Ready to hack the planet? >w<"
var dialogue_index = 0
var dialogue_complete = false

// 32 Hacking Rat Jokes for cute anime scriptkiddie girl
var dialogues = [
    "UwU! I'm Bawandar-chan! Ready to hack the planet? >w<",
    "My RAT isn't a rodent, it's a Remote Access Tool! But both like cheese... 🐭💻",
    "I don't hack systems... I just give them cute makeovers! Kawaii desu!",
    "Password cracking? More like password cuddling! *hugs keyboard*",
    "I put anime wallpapers on all the servers I breach. It's called aesthetic hacking!",
    "My hacking motto: If it doesn't have pink LEDs, it's not secure enough!",
    "I once DDoSed a server with too many cat videos. It was an a-meow-zing attack!",
    "Social engineering? I just tell people I'm a lost little girl who needs admin access. Works every time!",
    "Firewalls can't stop my cuteness overload! Nyaa~ 💕",
    "I compile my malware with rainbow syntax highlighting. It runs faster that way!",
    "SQL injection? More like SQL cuddle injection! *injects hugs*",
    "My backdoor has a hello kitty sticker on it. Hackers respect the aesthetic!",
    "I use a mechanical keyboard with sakura keycaps. The clicky sounds help me hack better!",
    "Zero-day exploits are just bugs that haven't received enough headpats yet!",
    "I protect my data with encryption and lots of anime stickers. Double security!",
    "Brute force attacks are so uncivilized. I use 'kawaii force' instead!",
    "My hacking toolkit: Kali Linux, a energy drink, and my lucky plushie!",
    "I once found a vulnerability so cute I almost didn't want to exploit it! Almost...",
    "Penetration testing is just giving systems little boops to see if they're friendly!",
    "I don't write malware, I write 'kawaii-ware'! It comes with virtual hugs!",
    "The blue screen of death is just the computer being tsundere. 'It's not like I wanted to crash!'",
    "I hack for justice, cute outfits, and unlimited bubble tea! The holy trinity!",
    "My RAT has anime eyes and says 'nya' when it connects. It's very effective!",
    "I put googly eyes on all the security cameras I breach. They look happier now!",
    "Hacking is just digital hide and seek! And I'm really good at hiding!",
    "I once replaced a company's login sound with 'ara ara~'. Productivity increased by 200%!",
    "My exploit code has more emojis than comments. It's my signature style! 💫",
    "I don't steal data... I borrow it for cuddle sessions!",
    "The pentagon's firewall is no match for my ultimate attack: 'Moe Moe Kyun!'",
    "I make all the passwords I crack say 'baka' at the end. It's my calling card!",
    "Hacking government systems is easy when you dress them up in virtual maid outfits!",
    "And that's how I became the world's cutest cyber threat! Want to be my hacking partner? 👾💖"
]

// Sprite sequences (1-32.png)
var sprites = []
for i := 1; i <= 32; i++ {
    sprites.push(format("sprite/%d.png", i))
}

var font_data = embed("fonts/ShadowsIntoLight-Regular.ttf")

fn draw(ctx) {
    ctx.hex("#ffffff") // White background
    ctx.clear()
    
    var img;
    var b;
    // Draw sprite
    if fs.exists(current_sprite) {
		img = image.load(current_sprite)
		b = img.bounds()
		// debug(b)
		img_data := fs.readfile(current_sprite)
        ctx.drawimage(img_data, 25, h/2 - b.size.height/2)
    } else {
        // if sprite doesn't exist
        ctx.hex("#ffb6c1") 
        ctx.rect(25, h/2 - 75, 150, 150)
        ctx.fill()
        ctx.hex("#000000")
        ctx.fontface(font_data, 20)
        ctx.text("Sprite: " + current_sprite, 40, h/2 - 20)
        ctx.text("Not found! >_<", 60, h/2 + 10)
        ctx.fill()
    }
    
    // dialogue box 
    ctx.hex("#ffebf2")
    ctx.rect(180, h/2 - 80, w - 205, 160)
    ctx.fill()
    
    // ctx.hex("#ff69b4") //pink
    // ctx.rect(180, h/2 - 80, w - 205, 160)
    // ctx.stroke()

    ctx.hex("#333333") 
    ctx.fontface(font_data, 18)
    
    // Wrap text
    var words = strings.split(current_dialogue, " ")
    var line = ""
    var lines = []
    var max_width = w - 240
    
    for word in words {
        var test_line = line + word + " "
        var metrics = ctx.measure_text(test_line)
        if metrics[0] > max_width && line != "" {
            lines.push(line)
            line = word + " "
        } else {
            line = test_line
        }
    }
    lines.push(line)
    
  
    for i, text_line in lines {
        ctx.text(text_line, 200, h/2 - 50 + (i * 22))
        ctx.fill()
    }
    

    if dialogue_index < dialogues.length - 1 {
        ctx.hex("#ff1493") // Deep pink
        ctx.fontface(font_data, 18)
        var bounce = math.sin(randint(0,100)) * 3 // Bouncing animation
        ctx.text("Click to continue~", w - 180, h/2 + 60 + bounce)
        ctx.fill()
    } else {
        // Final message
        ctx.hex("#ff1493")
        ctx.text("The End! Thanks for playing!", w - 280, h/2 + 60)
        ctx.fill()
    }
    
    // Draw progress indicator
    ctx.hex("#ffb6c150") // Light pink progress background
    ctx.rect(180, h/2 - 95, w - 205, 10)
    ctx.fill()
    
    ctx.hex("#ff69b4") // Progress bar
    var progress_width = (w - 205) * (dialogue_index + 1) / dialogues.length
    ctx.rect(180, h/2 - 95, progress_width, 10)
    ctx.fill()
    
    // Draw current dialogue number
    ctx.hex("#888888")
    ctx.fontface(font_data, 12)
    ctx.text(format("%d/%d", dialogue_index + 1, dialogues.length), w - 120, h/2 - 100)
    ctx.fill()
}

fn advance_dialogue() {
    if dialogue_index < dialogues.length - 1 {
        dialogue_index += 1
        current_dialogue = dialogues[dialogue_index]
        current_sprite = sprites[dialogue_index]
        dialogue_complete = false
    } else {
        // loop back to start
        dialogue_index = 0
        current_dialogue = dialogues[0]
        current_sprite = sprites[0]
        dialogue_complete = true
    }
}

var options = {
    width: w,
    height: h,
    title: "Bawandar RAT; Dennou!",
    fullscreen: false,
    borderless: false,
    top_most: false,
    no_scaling: false,
    x: 250,
    y: 130
}

canvas.new_window(options, fn(window){
    ctx := window.new_context(w, h)
    
    draw(ctx)
    window.update(w, h)
    
    for {
        e := window.next_event()
        if e.type == "size" {
            w = e.width_px 
            h = e.height_px
            ctx = window.new_context(e.width_px, e.height_px)
            draw(ctx)
            window.update(w, h)
        }
        else if e.type == "lifecycle" && e.from == 3 && e.to == 0 {
            break
        }
        else if e.type == "mouse" && e.direction == 1 {
            // dvance dialogue
            advance_dialogue()
            draw(ctx)
            window.update(w, h)
        }
        else if e.type == "tick" {
            draw(ctx)
            window.update(w, h)
        }
    }
})
