//
//  Utilities.swift
//  CMONWWDC
//
//  Created by Orlando Aprea on 24/03/17.
//  Copyright © 2017 Orlando Aprea. All rights reserved.
//

//here there are all the global constants and enums used into the playground (names are quite self explicative)

let MIDIInstruments:[String:UInt8] = [
    "Acoustic Grand Piano" : 0, "Bright Acoustic Piano" : 1, "Electric Grand Piano" : 2, "Honky-tonk Piano" : 3,
    "Electric Piano 1" : 4,     "Electric Piano 2" : 5,      "Harpsichord" : 6,          "Clavi" : 7,
    "Celesta" : 8,              "Glockenspiel" : 9,          "Music Box" : 10,           "Vibraphone" : 11,
    "Marimba" : 12,             "Xylophone" : 13,            "Tubular Bells" : 14,       "Dulcimer" : 15,
    "Drawbar Organ" : 16,       "Percussive Organ" : 17,     "Rock Organ" : 18,          "ChurchPipe" : 19,
    "Positive" : 20,            "Accordion" : 21,            "Harmonica" : 22,           "Tango Accordion" : 23,
    "Classic Guitar" : 24,      "Acoustic Guitar" : 25,      "Jazz Guitar" : 26,         "Clean Guitar" : 27,
    "Muted Guitar" : 28,        "Overdriven Guitar" : 29,    "Distortion Guitar" : 30,   "Guitar harmonics" : 31,
    "JazzBass" : 32,            "DeepBass" : 33,             "PickBass" : 34,            "FretLess" : 35,
    "SlapBass1" : 36,           "SlapBass2" : 37,            "SynthBass1" : 38,          "SynthBass2" : 39,
    "Violin" : 40,              "Viola" : 41,                "Cello" : 42,               "ContraBass" : 43,
    "TremoloStr" : 44,          "Pizzicato" : 45,            "Harp" : 46,                "Timpani" : 47,
    "String Ensemble 1" : 48,   "String Ensemble 2" : 49,    "SynthStrings 1" : 50,      "SynthStrings 2" : 51,
    "Choir" : 52,               "DooVoice" : 53,             "Voices" : 54,              "OrchHit" : 55,
    "Trumpet" : 56,             "Trombone" : 57,             "Tuba" : 58,                "MutedTrumpet" : 59,
    "FrenchHorn" : 60,          "Brass" : 61,                "SynBrass1" : 62,           "SynBrass2" : 63,
    "SopranoSax" : 64,          "AltoSax" : 65,              "TenorSax" : 66,            "BariSax" : 67,
    "Oboe" : 68,                "EnglishHorn" : 69,          "Bassoon" : 70,             "Clarinet" : 71,
    "Piccolo" : 72,             "Flute" : 73,                "Recorder" : 74,            "PanFlute" : 75,
    "Bottle" : 76,              "Shakuhachi" : 77,           "Whistle" : 78,             "Ocarina" : 79,
    "SquareWave" : 80,          "SawWave" : 81,              "Calliope" : 82,            "SynChiff" : 83,
    "Charang" : 84,             "AirChorus" : 85,            "fifths" : 86,              "BassLead" : 87,
    "New Age" : 88,             "WarmPad" : 89,              "PolyPad" : 90,             "GhostPad" : 91,
    "BowedGlas" : 92,           "MetalPad" : 93,             "HaloPad" : 94,             "Sweep" : 95,
    "IceRain" : 96,             "SoundTrack" : 97,           "Crystal" : 98,             "Atmosphere" : 99,
    "Brightness" : 100,         "Goblin" : 101,              "EchoDrop" : 102,           "SciFi effect" : 103,
    "Sitar" : 104,              "Banjo" : 105,               "Shamisen" : 106,           "Koto" : 107,
    "Kalimba" : 108,            "Scotland" : 109,            "Fiddle" : 110,             "Shanai" : 111,
    "MetalBell" : 112,          "Agogo" : 113,               "SteelDrums" : 114,         "Woodblock" : 115,
    "Taiko" : 116,              "Tom" : 117,                 "SynthTom" : 118,           "RevCymbal" : 119,
    "FretNoise" : 120,          "NoiseChiff" : 121,          "Seashore" : 122,           "Birds" : 123,
    "Telephone" : 124,          "Helicopter" : 125,          "Stadium" : 126,            "GunShot" : 127
]


public enum NoteDuration: Double {
    case semiquaver = 1
    case quaver     = 2
    case crotchet   = 4
    case halfNote   = 8
}

enum NoteNumbers: UInt8 {
    
    case C = 0,
    Cdiesis = 1,
    D       = 2,
    Ddiesis = 3,
    E       = 4,
    F       = 5,
    Fdiesis = 6,
    G       = 7,
    Gdiesis = 8,
    A       = 9,
    Adiesis = 10,
    B       = 11
    
    
    func getNext() -> NoteNumbers {
        switch self {
        case .C:
            return NoteNumbers.D
        case .D:
            return NoteNumbers.E
        case .E:
            return NoteNumbers.F
        case .F:
            return NoteNumbers.G
        case .G:
            return NoteNumbers.A
        case .A:
            return NoteNumbers.B
        case .B:
            return NoteNumbers.C
        default:
            return NoteNumbers.C
        }
        
    }
    
    func applyOctave ( octave: Octave ) -> NoteNumbers.RawValue {
        return self.rawValue + (octave.rawValue * Octave.RawValue(12))
    }
}

public enum ChordNames: String {
    case C = "C"
    case Cm = "Cm"
    case Cdiesis = "Cdiesis"
    case D = "D"
    case Dm = "Dm"
    case Ddiesis = "Ddiesis"
    case E = "E"
    case Em = "Em"
    case F = "F"
    case Fm = "Fm"
    case Fdiesis = "Fdiesis"
    case G = "G"
    case Gm = "Gm"
    case Gdiesis = "Gdiesis"
    case A = "A"
    case Am = "Am"
    case Adiesis = "Adiesis"
    case B = "B"
    case Bm = "Bm"
}

public enum Octave: UInt8 {
    case one   = 1
    case two   = 2
    case three = 3
    case four  = 4
    case five  = 5
    case six   = 6
    case seven = 7
    case eight = 8
    case nine  = 9
    case ten   = 10
    
    func getNext() -> Octave.RawValue {
        return (self.rawValue + 1) < 10 ? (self.rawValue + 1) : Octave.RawValue(0)
    }
    
}

enum KindOfEffect: String {
    case none = "none"
    case lightLaser = "lightLaser"
    case firework = "firework"
    case light = "light"
    case click = "click"
    case meteorite = "meteorite"
    case flare = "flare"
    case bubble = "bubble"
    
    static func getFromString(value: String)->KindOfEffect{
        switch value {
        case KindOfEffect.bubble.rawValue:
            return KindOfEffect.bubble
        case KindOfEffect.click.rawValue:
            return KindOfEffect.click
        case KindOfEffect.firework.rawValue:
            return KindOfEffect.firework
        case KindOfEffect.flare.rawValue:
            return KindOfEffect.flare
        case KindOfEffect.light.rawValue:
            return KindOfEffect.light
        case KindOfEffect.lightLaser.rawValue:
            return KindOfEffect.lightLaser
        case KindOfEffect.meteorite.rawValue:
            return KindOfEffect.meteorite
        default:
            break
        }
        return KindOfEffect.none
    }
    
}

let EffectsDictionary: [KindOfEffect] = [KindOfEffect.bubble,
                                         KindOfEffect.click,
                                         KindOfEffect.firework,
                                         KindOfEffect.flare,
                                         KindOfEffect.light,
                                         KindOfEffect.lightLaser,
                                         KindOfEffect.meteorite]



let ChordComposition: [ChordNames: [NoteNumbers]] = [
    .C:       [NoteNumbers.C,
               NoteNumbers.E,
               NoteNumbers.G],
    .Cm:      [NoteNumbers.C,
               NoteNumbers.Ddiesis,
               NoteNumbers.G],
    .Cdiesis: [NoteNumbers.Cdiesis,
               NoteNumbers.F,
               NoteNumbers.Gdiesis],
    .D:       [NoteNumbers.D,
               NoteNumbers.Fdiesis,
               NoteNumbers.A],
    .Dm:      [NoteNumbers.D,
               NoteNumbers.F,
               NoteNumbers.A],
    .Ddiesis: [NoteNumbers.Ddiesis,
               NoteNumbers.G,
               NoteNumbers.Adiesis],
    .E:       [NoteNumbers.E,
               NoteNumbers.Gdiesis,
               NoteNumbers.B],
    .Em:      [NoteNumbers.E,
               NoteNumbers.G,
               NoteNumbers.B],
    .F:       [NoteNumbers.F,
               NoteNumbers.A,
               NoteNumbers.C],
    .Fm:      [NoteNumbers.F,
               NoteNumbers.Gdiesis,
               NoteNumbers.C],
    .Fdiesis: [NoteNumbers.Fdiesis,
               NoteNumbers.Adiesis,
               NoteNumbers.Cdiesis],
    .G:       [NoteNumbers.G,
               NoteNumbers.B,
               NoteNumbers.D],
    .Gm:      [NoteNumbers.G,
               NoteNumbers.Adiesis,
               NoteNumbers.D],
    .Gdiesis: [NoteNumbers.Gdiesis,
               NoteNumbers.C,
               NoteNumbers.Ddiesis],
    .A:       [NoteNumbers.A,
               NoteNumbers.Cdiesis,
               NoteNumbers.E],
    .Am:      [NoteNumbers.A,
               NoteNumbers.C,
               NoteNumbers.E],
    .Adiesis: [NoteNumbers.Adiesis,
               NoteNumbers.D,
               NoteNumbers.F],
    .B:       [NoteNumbers.B,
               NoteNumbers.Ddiesis,
               NoteNumbers.Fdiesis],
    .Bm:      [NoteNumbers.B,
               NoteNumbers.D,
               NoteNumbers.Fdiesis]]




