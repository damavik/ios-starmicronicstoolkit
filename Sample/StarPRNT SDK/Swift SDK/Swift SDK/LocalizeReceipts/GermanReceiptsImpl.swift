//
//  GermanReceiptsImpl.swift
//  Swift SDK
//
//  Created by Yuji on 2016/**/**.
//  Copyright © 2016年 Star Micronics. All rights reserved.
//

import Foundation

class GermanReceiptsImpl: ILocalizeReceipts {
    override init() {
        super.init()
        
        languageCode = "De"
    }
    
    override func append2inchTextReceiptData(builder: ISCBBuilder, utf8: Bool) {
        let encoding: NSStringEncoding
        
        if utf8 == true {
            encoding = NSUTF8StringEncoding
            
            builder.appendCodePage(SCBCodePageType.UTF8)
        }
        else {
            encoding = NSWindowsCP1252StringEncoding
            
            builder.appendCodePage(SCBCodePageType.CP1252)
        }
        
        builder.appendInternational(SCBInternationalType.Germany)
        
        builder.appendCharacterSpace(0)
        
        builder.appendAlignment(SCBAlignmentPosition.Center)
        
        builder.appendDataWithMultiple((
            "STAR\n" +
            "Supermarkt\n").dataUsingEncoding(encoding), width: 2, height: 2)
        
        builder.appendData((
            "\n" +
            "Das Internet von seiner\n" +
            "genussvollsten Seite\n" +
            "\n").dataUsingEncoding(encoding))
        
        builder.appendDataWithMultipleHeight(("www.Star-EMEM.com\n").dataUsingEncoding(encoding), height: 2)
        
        builder.appendData(("Gebührenfrei Rufnummer:\n").dataUsingEncoding(encoding))
        
        builder.appendDataWithEmphasis(("08006646701\n").dataUsingEncoding(encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.Left)
        
        builder.appendData(("--------------------------------\n").dataUsingEncoding(encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.Right)
        
        builder.appendDataWithEmphasis(("EUR\n").dataUsingEncoding(encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.Left)
        
        builder.appendData((
            "Schmand 24%                 0.42\n" +
            "Kefir                       0.79\n" +
            "Haarspray                   1.79\n" +
            "Gurken ST                   0.59\n" +
            "Mandelknacker               1.59\n" +
            "Mandelknacker               1.59\n" +
            "Nussecken                   1.69\n" +
            "Nussecken                   1.69\n" +
            "Clemen.1kg NZ               1.49\n" +
            "2X\n" +
            "Zitronen ST                 1.18\n" +
            "4X\n" +
            "Grapefruit                  3.16\n" +
            "Party Garnelen              9.79\n" +
            "Apfelsaft                   1.39\n" +
            "Lauchzw./Schl.B             0.49\n" +
            "Butter                      1.19\n" +
            "Profi-Haartrockner         27.99\n" +
            "Mozarella 45%               0.59\n" +
            "Mozarella 45%               0.59\n" +
            "Bruschetta Brot             0.59\n" +
            "Weizenmehl                  0.39\n" +
            "Jodsalz                     0.19\n" +
            "Eier M braun Bod            1.79\n" +
            "Schlagsahne                 1.69\n" +
            "Schlagsahne                 1.69\n" +
            "\n" +
            "Rueckgeld              EUR  0.00\n" +
            "\n" +
            "19.00% MwSt.               13.14\n" +
            "NETTO-UMSATZ               82.33\n" +
            "--------------------------------\n" +
            "KontoNr:  0551716000 / 0 / 0512\n" +
            "BLZ:      58862159\n" +
            "Trace-Nr: 027929\n" +
            "Beleg:    7238\n" +
            "--------------------------------\n" +
            "Kas: 003/006    Bon  0377 PC01 P\n" +
            "Dat: 30.03.2015 Zeit 18:06:01 43\n" +
            "\n").dataUsingEncoding(encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.Center)
        
        builder.appendData((
            "USt–ID:    DE125580123\n" +
            "\n").dataUsingEncoding(encoding))
        
        builder.appendDataWithEmphasis((
            "Vielen dank\n" +
            "für Ihren Einkauf!\n" +
            "\n").dataUsingEncoding(encoding))
        
//      builder.appendBarcodeData("{BStar.".dataUsingEncoding(encoding),              symbology: SCBBarcodeSymbology.Code128, width: SCBBarcodeWidth.Mode2, height: 40, hri: true)
        builder.appendBarcodeData("{BStar.".dataUsingEncoding(NSASCIIStringEncoding), symbology: SCBBarcodeSymbology.Code128, width: SCBBarcodeWidth.Mode2, height: 40, hri: true)
    }
    
    override func append3inchTextReceiptData(builder: ISCBBuilder, utf8: Bool) {
        let encoding: NSStringEncoding
        
        if utf8 == true {
            encoding = NSUTF8StringEncoding
            
            builder.appendCodePage(SCBCodePageType.UTF8)
        }
        else {
            encoding = NSWindowsCP1252StringEncoding
            
            builder.appendCodePage(SCBCodePageType.CP1252)
        }
        
        builder.appendInternational(SCBInternationalType.Germany)
        
        builder.appendCharacterSpace(0)
        
        builder.appendAlignment(SCBAlignmentPosition.Center)
        
        builder.appendDataWithMultiple((
            "STAR\n" +
            "Supermarkt\n").dataUsingEncoding(encoding), width: 2, height: 2)
        
        builder.appendData((
            "\n" +
            "Das Internet von seiner genussvollsten Seite\n" +
            "\n").dataUsingEncoding(encoding))
        
        builder.appendDataWithMultipleHeight(("www.Star-EMEM.com\n").dataUsingEncoding(encoding), height: 2)
        
        builder.appendData(("Gebührenfrei Rufnummer:\n").dataUsingEncoding(encoding))
        
        builder.appendDataWithEmphasis(("08006646701\n").dataUsingEncoding(encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.Left)
        
        builder.appendData(("------------------------------------------------\n").dataUsingEncoding(encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.Right)
        
        builder.appendDataWithEmphasis(("EUR\n").dataUsingEncoding(encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.Left)
        
        builder.appendData((
            "Schmand 24%                                 0.42\n" +
            "Kefir                                       0.79\n" +
            "Haarspray                                   1.79\n" +
            "Gurken ST                                   0.59\n" +
            "Mandelknacker                               1.59\n" +
            "Mandelknacker                               1.59\n" +
            "Nussecken                                   1.69\n" +
            "Nussecken                                   1.69\n" +
            "Clemen.1kg NZ                               1.49\n" +
            "2X\n" +
            "Zitronen ST                                 1.18\n" +
            "4X\n" +
            "Grapefruit                                  3.16\n" +
            "Party Garnelen                              9.79\n" +
            "Apfelsaft                                   1.39\n" +
            "Lauchzw./Schl.B                             0.49\n" +
            "Butter                                      1.19\n" +
            "Profi-Haartrockner                         27.99\n" +
            "Mozarella 45%                               0.59\n" +
            "Mozarella 45%                               0.59\n" +
            "Bruschetta Brot                             0.59\n" +
            "Weizenmehl                                  0.39\n" +
            "Jodsalz                                     0.19\n" +
            "Eier M braun Bod                            1.79\n" +
            "Schlagsahne                                 1.69\n" +
            "Schlagsahne                                 1.69\n" +
            "\n" +
            "Rueckgeld                              EUR  0.00\n" +
            "\n" +
            "19.00% MwSt.                               13.14\n" +
            "NETTO-UMSATZ                               82.33\n" +
            "------------------------------------------------\n" +
            "KontoNr:  0551716000 / 0 / 0512\n" +
            "BLZ:      58862159\n" +
            "Trace-Nr: 027929\n" +
            "Beleg:    7238\n" +
            "------------------------------------------------\n" +
            "Kas: 003/006    Bon  0377 PC01 P\n" +
            "Dat: 30.03.2015 Zeit 18:06:01 43\n" +
            "\n").dataUsingEncoding(encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.Center)
        
        builder.appendData((
            "USt–ID:    DE125580123\n" +
            "\n").dataUsingEncoding(encoding))
        
        builder.appendDataWithEmphasis((
            "Vielen dank\n" +
            "für Ihren Einkauf!\n" +
            "\n").dataUsingEncoding(encoding))
        
//      builder.appendBarcodeData("{BStar.".dataUsingEncoding(encoding),              symbology: SCBBarcodeSymbology.Code128, width: SCBBarcodeWidth.Mode2, height: 40, hri: true)
        builder.appendBarcodeData("{BStar.".dataUsingEncoding(NSASCIIStringEncoding), symbology: SCBBarcodeSymbology.Code128, width: SCBBarcodeWidth.Mode2, height: 40, hri: true)
    }
    
    override func append4inchTextReceiptData(builder: ISCBBuilder, utf8: Bool) {
        let encoding: NSStringEncoding
        
        if utf8 == true {
            encoding = NSUTF8StringEncoding
            
            builder.appendCodePage(SCBCodePageType.UTF8)
        }
        else {
            encoding = NSWindowsCP1252StringEncoding
            
            builder.appendCodePage(SCBCodePageType.CP1252)
        }
        
        builder.appendInternational(SCBInternationalType.Germany)
        
        builder.appendCharacterSpace(0)
        
        builder.appendAlignment(SCBAlignmentPosition.Center)
        
        builder.appendDataWithMultiple((
            "STAR\n" +
            "Supermarkt\n").dataUsingEncoding(encoding), width: 2, height: 2)
        
        builder.appendData((
            "\n" +
            "Das Internet von seiner genussvollsten Seite\n" +
            "\n").dataUsingEncoding(encoding))
        
        builder.appendDataWithMultipleHeight(("www.Star-EMEM.com\n").dataUsingEncoding(encoding), height: 2)
        
        builder.appendData(("Gebührenfrei Rufnummer:\n").dataUsingEncoding(encoding))
        
        builder.appendDataWithEmphasis(("08006646701\n").dataUsingEncoding(encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.Left)
        
        builder.appendData(("---------------------------------------------------------------------\n").dataUsingEncoding(encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.Right)
        
        builder.appendDataWithEmphasis(("EUR\n").dataUsingEncoding(encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.Left)
        
        builder.appendData((
            "Schmand 24%                                                      0.42\n" +
            "Kefir                                                            0.79\n" +
            "Haarspray                                                        1.79\n" +
            "Gurken ST                                                        0.59\n" +
            "Mandelknacker                                                    1.59\n" +
            "Mandelknacker                                                    1.59\n" +
            "Nussecken                                                        1.69\n" +
            "Nussecken                                                        1.69\n" +
            "Clemen.1kg NZ                                                    1.49\n" +
            "2X\n" +
            "Zitronen ST                                                      1.18\n" +
            "4X\n" +
            "Grapefruit                                                       3.16\n" +
            "Party Garnelen                                                   9.79\n" +
            "Apfelsaft                                                        1.39\n" +
            "Lauchzw./Schl.B                                                  0.49\n" +
            "Butter                                                           1.19\n" +
            "Profi-Haartrockner                                              27.99\n" +
            "Mozarella 45%                                                    0.59\n" +
            "Mozarella 45%                                                    0.59\n" +
            "Bruschetta Brot                                                  0.59\n" +
            "Weizenmehl                                                       0.39\n" +
            "Jodsalz                                                          0.19\n" +
            "Eier M braun Bod                                                 1.79\n" +
            "Schlagsahne                                                      1.69\n" +
            "Schlagsahne                                                      1.69\n" +
            "\n" +
            "Rueckgeld                                                   EUR  0.00\n" +
            "\n" +
            "19.00% MwSt.                                                    13.14\n" +
            "NETTO-UMSATZ                                                    82.33\n" +
            "---------------------------------------------------------------------\n" +
            "KontoNr:  0551716000 / 0 / 0512\n" +
            "BLZ:      58862159\n" +
            "Trace-Nr: 027929\n" +
            "Beleg:    7238\n" +
            "---------------------------------------------------------------------\n" +
            "Kas: 003/006    Bon  0377 PC01 P\n" +
            "Dat: 30.03.2015 Zeit 18:06:01 43\n" +
            "\n").dataUsingEncoding(encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.Center)
        
        builder.appendData((
            "USt–ID:    DE125580123\n" +
            "\n").dataUsingEncoding(encoding))
        
        builder.appendDataWithEmphasis((
            "Vielen dank\n" +
            "für Ihren Einkauf!\n" +
            "\n").dataUsingEncoding(encoding))
        
//      builder.appendBarcodeData("{BStar.".dataUsingEncoding(encoding),              symbology: SCBBarcodeSymbology.Code128, width: SCBBarcodeWidth.Mode2, height: 40, hri: true)
        builder.appendBarcodeData("{BStar.".dataUsingEncoding(NSASCIIStringEncoding), symbology: SCBBarcodeSymbology.Code128, width: SCBBarcodeWidth.Mode2, height: 40, hri: true)
    }
    
    override func create2inchRasterReceiptImage() -> UIImage {
        let textToPrint: String =
        "           STAR\n" +
        "        Supermarkt\n" +
        "\n" +
        " Das Internet von seiner\n" +
        "   genussvollsten Seite\n" +
        "\n" +
        "    www.Star-EMEM.com\n" +
        " Gebührenfrei Rufnummer:\n" +
        "       08006646701\n" +
        "--------------------------\n" +
        "                       EUR\n" +
        "Schmand 24%           0.42\n" +
        "Kefir                 0.79\n" +
        "Haarspray             1.79\n" +
        "Gurken ST             0.59\n" +
        "Mandelknacker         1.59\n" +
        "Mandelknacker         1.59\n" +
        "Nussecken             1.69\n" +
        "Nussecken             1.69\n" +
        "Clemen.1kg NZ         1.49\n" +
        "2X\n" +
        "Zitronen ST           1.18\n" +
        "4X\n" +
        "Grapefruit            3.16\n" +
        "Party Garnelen        9.79\n" +
        "Apfelsaft             1.39\n" +
        "Lauchzw./Schl.B       0.49\n" +
        "Butter                1.19\n" +
        "Profi-Haartrockner   27.99\n" +
        "Mozarella 45%         0.59\n" +
        "Mozarella 45%         0.59\n" +
        "Bruschetta Brot       0.59\n" +
        "Weizenmehl            0.39\n" +
        "Jodsalz               0.19\n" +
        "Eier M braun Bod      1.79\n" +
        "Schlagsahne           1.69\n" +
        "Schlagsahne           1.69\n" +
        "\n" +
        "Rueckgeld        EUR  0.00\n" +
        "\n" +
        "19.00% MwSt.         13.14\n" +
        "NETTO-UMSATZ         82.33\n" +
        "--------------------------\n" +
        "KontoNr: 0551716000/0/0512\n" +
        "BLZ:     58862159\n" +
        "Trace-Nr:027929\n" +
        "Beleg:   7238\n" +
        "--------------------------\n" +
        "Kas:003/006 Bon0377 PC01 P\n" +
        "Dat:30.03.2015\n" +
        "Zeit18:06:01            43\n" +
        "\n" +
        "  USt–ID:    DE125580123\n" +
        "\n" +
        "       Vielen dank\n" +
        "    für Ihren Einkauf!\n"
        
        let font: UIFont = UIFont(name: "Menlo", size: 12 * 2)!
        
        return ILocalizeReceipts.imageWithString(textToPrint, font: font, width: 384)     // 2inch(384dots)
    }
    
    override func create3inchRasterReceiptImage() -> UIImage {
        let textToPrint: String =
        "                 STAR\n" +
        "              Supermarkt\n" +
        "\n" +
        "       Das Internet von seiner\n" +
        "         genussvollsten Seite\n" +
        "\n" +
        "          www.Star-EMEM.com\n" +
        "       Gebührenfrei Rufnummer:\n" +
        "             08006646701\n" +
        "--------------------------------------\n" +
        "                                   EUR\n" +
        "Schmand 24%                       0.42\n" +
        "Kefir                             0.79\n" +
        "Haarspray                         1.79\n" +
        "Gurken ST                         0.59\n" +
        "Mandelknacker                     1.59\n" +
        "Mandelknacker                     1.59\n" +
        "Nussecken                         1.69\n" +
        "Nussecken                         1.69\n" +
        "Clemen.1kg NZ                     1.49\n" +
        "2X\n" +
        "Zitronen ST                       1.18\n" +
        "4X\n" +
        "Grapefruit                        3.16\n" +
        "Party Garnelen                    9.79\n" +
        "Apfelsaft                         1.39\n" +
        "Lauchzw./Schl.B                   0.49\n" +
        "Butter                            1.19\n" +
        "Profi-Haartrockner               27.99\n" +
        "Mozarella 45%                     0.59\n" +
        "Mozarella 45%                     0.59\n" +
        "Bruschetta Brot                   0.59\n" +
        "Weizenmehl                        0.39\n" +
        "Jodsalz                           0.19\n" +
        "Eier M braun Bod                  1.79\n" +
        "Schlagsahne                       1.69\n" +
        "Schlagsahne                       1.69\n" +
        "\n" +
        "Rueckgeld                    EUR  0.00\n" +
        "\n" +
        "19.00% MwSt.                     13.14\n" +
        "NETTO-UMSATZ                     82.33\n" +
        "--------------------------------------\n" +
        "KontoNr:  0551716000 / 0 / 0512\n" +
        "BLZ:      58862159\n" +
        "Trace-Nr: 027929\n" +
        "Beleg:    7238\n" +
        "--------------------------------------\n" +
        "Kas: 003/006    Bon  0377 PC01 P\n" +
        "Dat: 30.03.2015 Zeit 18:06:01 43\n" +
        "\n" +
        "        USt–ID:    DE125580123\n" +
        "\n" +
        "             Vielen dank\n" +
        "          für Ihren Einkauf!\n"
        
        let font: UIFont = UIFont(name: "Menlo", size: 12 * 2)!
        
        return ILocalizeReceipts.imageWithString(textToPrint, font: font, width: 576)     // 3inch(576dots)
    }
    
    override func create4inchRasterReceiptImage() -> UIImage {
        let textToPrint: String =
        "                          STAR\n" +
        "                       Supermarkt\n" +
        "\n" +
        "                Das Internet von seiner\n" +
        "                  genussvollsten Seite\n" +
        "\n" +
        "                   www.Star-EMEM.com\n" +
        "                Gebührenfrei Rufnummer:\n" +
        "                      08006646701\n" +
        "---------------------------------------------------------\n" +
        "                                                      EUR\n" +
        "Schmand 24%                                          0.42\n" +
        "Kefir                                                0.79\n" +
        "Haarspray                                            1.79\n" +
        "Gurken ST                                            0.59\n" +
        "Mandelknacker                                        1.59\n" +
        "Mandelknacker                                        1.59\n" +
        "Nussecken                                            1.69\n" +
        "Nussecken                                            1.69\n" +
        "Clemen.1kg NZ                                        1.49\n" +
        "2X\n" +
        "Zitronen ST                                          1.18\n" +
        "4X\n" +
        "Grapefruit                                           3.16\n" +
        "Party Garnelen                                       9.79\n" +
        "Apfelsaft                                            1.39\n" +
        "Lauchzw./Schl.B                                      0.49\n" +
        "Butter                                               1.19\n" +
        "Profi-Haartrockner                                  27.99\n" +
        "Mozarella 45%                                        0.59\n" +
        "Mozarella 45%                                        0.59\n" +
        "Bruschetta Brot                                      0.59\n" +
        "Weizenmehl                                           0.39\n" +
        "Jodsalz                                              0.19\n" +
        "Eier M braun Bod                                     1.79\n" +
        "Schlagsahne                                          1.69\n" +
        "Schlagsahne                                          1.69\n" +
        "\n" +
        "Rueckgeld                                       EUR  0.00\n" +
        "\n" +
        "19.00% MwSt.                                        13.14\n" +
        "NETTO-UMSATZ                                        82.33\n" +
        "---------------------------------------------------------\n" +
        "KontoNr:  0551716000 / 0 / 0512\n" +
        "BLZ:      58862159\n" +
        "Trace-Nr: 027929\n" +
        "Beleg:    7238\n" +
        "---------------------------------------------------------\n" +
        "Kas: 003/006    Bon  0377 PC01 P\n" +
        "Dat: 30.03.2015 Zeit 18:06:01 43\n" +
        "\n" +
        "                 USt–ID:    DE125580123\n" +
        "\n" +
        "                      Vielen dank\n" +
        "                   für Ihren Einkauf!\n"
        
        let font: UIFont = UIFont(name: "Menlo", size: 12 * 2)!
        
        return ILocalizeReceipts.imageWithString(textToPrint, font: font, width: 832)     // 4inch(832dots)
    }
    
    override func createCouponImage() -> UIImage {
        return UIImage(named: "GermanCouponImage.png")!
    }
    
    override func createEscPos3inchRasterReceiptImage() -> UIImage {
        let textToPrint: String =
        "               STAR\n" +
        "            Supermarkt\n" +
        "\n" +
        "      Das Internet von seiner\n" +
        "       genussvollsten Seite\n" +
        "\n" +
        "         www.Star-EMEM.com\n" +
        "      Gebührenfrei Rufnummer:\n" +
        "            08006646701\n" +
        "-----------------------------------\n" +
        "                                EUR\n" +
        "Schmand 24%                    0.42\n" +
        "Kefir                          0.79\n" +
        "Haarspray                      1.79\n" +
        "Gurken ST                      0.59\n" +
        "Mandelknacker                  1.59\n" +
        "Mandelknacker                  1.59\n" +
        "Nussecken                      1.69\n" +
        "Nussecken                      1.69\n" +
        "Clemen.1kg NZ                  1.49\n" +
        "2X\n" +
        "Zitronen ST                    1.18\n" +
        "4X\n" +
        "Grapefruit                     3.16\n" +
        "Party Garnelen                 9.79\n" +
        "Apfelsaft                      1.39\n" +
        "Lauchzw./Schl.B                0.49\n" +
        "Butter                         1.19\n" +
        "Profi-Haartrockner            27.99\n" +
        "Mozarella 45%                  0.59\n" +
        "Mozarella 45%                  0.59\n" +
        "Bruschetta Brot                0.59\n" +
        "Weizenmehl                     0.39\n" +
        "Jodsalz                        0.19\n" +
        "Eier M braun Bod               1.79\n" +
        "Schlagsahne                    1.69\n" +
        "Schlagsahne                    1.69\n" +
        "\n" +
        "Rueckgeld                 EUR  0.00\n" +
        "\n" +
        "19.00% MwSt.                  13.14\n" +
        "NETTO-UMSATZ                  82.33\n" +
        "-----------------------------------\n" +
        "KontoNr:  0551716000 / 0 / 0512\n" +
        "BLZ:      58862159\n" +
        "Trace-Nr: 027929\n" +
        "Beleg:    7238\n" +
        "-----------------------------------\n" +
        "Kas: 003/006    Bon  0377 PC01 P\n" +
        "Dat: 30.03.2015 Zeit 18:06:01 43\n" +
        "\n" +
        "      USt–ID:    DE125580123\n" +
        "\n" +
        "            Vielen dank\n" +
        "        für Ihren Einkauf!\n"
        
        let font: UIFont = UIFont(name: "Menlo", size: 12 * 2)!
        
        return ILocalizeReceipts.imageWithString(textToPrint, font: font, width: 512)     // EscPos3inch(512dots)
    }
    
    override func appendEscPos3inchTextReceiptData(builder: ISCBBuilder, utf8: Bool) {
        let encoding: NSStringEncoding
        
        if utf8 == true {
            encoding = NSUTF8StringEncoding
            
            builder.appendCodePage(SCBCodePageType.UTF8)
        }
        else {
            encoding = NSWindowsCP1252StringEncoding
            
            builder.appendCodePage(SCBCodePageType.CP1252)
        }
        
        builder.appendInternational(SCBInternationalType.Germany)
        
        builder.appendCharacterSpace(0)
        
        builder.appendAlignment(SCBAlignmentPosition.Center)
        
        builder.appendDataWithMultiple((
            "STAR\n" +
            "Supermarkt\n").dataUsingEncoding(encoding), width: 2, height: 2)
        
        builder.appendData((
            "\n" +
            "Das Internet von seiner\n" +
            "genussvollsten Seite\n" +
            "\n").dataUsingEncoding(encoding))
        
        builder.appendDataWithMultipleHeight(("www.Star-EMEM.com\n").dataUsingEncoding(encoding), height: 2)
        
        builder.appendData(("Gebührenfrei Rufnummer:\n").dataUsingEncoding(encoding))
        
        builder.appendDataWithEmphasis(("08006646701\n").dataUsingEncoding(encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.Left)
        
        builder.appendData(("------------------------------------------\n").dataUsingEncoding(encoding))
        
        builder.appendDataWithEmphasis(("                                       EUR\n").dataUsingEncoding(encoding))
        
        builder.appendData((
            "Schmand 24%                           0.42\n" +
            "Kefir                                 0.79\n" +
            "Haarspray                             1.79\n" +
            "Gurken ST                             0.59\n" +
            "Mandelknacker                         1.59\n" +
            "Mandelknacker                         1.59\n" +
            "Nussecken                             1.69\n" +
            "Nussecken                             1.69\n" +
            "Clemen.1kg NZ                         1.49\n" +
            "2X\n" +
            "Zitronen ST                           1.18\n" +
            "4X\n" +
            "Grapefruit                            3.16\n" +
            "Party Garnelen                        9.79\n" +
            "Apfelsaft                             1.39\n" +
            "Lauchzw./Schl.B                       0.49\n" +
            "Butter                                1.19\n" +
            "Profi-Haartrockner                   27.99\n" +
            "Mozarella 45%                         0.59\n" +
            "Mozarella 45%                         0.59\n" +
            "Bruschetta Brot                       0.59\n" +
            "Weizenmehl                            0.39\n" +
            "Jodsalz                               0.19\n" +
            "Eier M braun Bod                      1.79\n" +
            "Schlagsahne                           1.69\n" +
            "Schlagsahne                           1.69\n" +
            "\n" +
            "Rueckgeld                        EUR  0.00\n" +
            "\n" +
            "19.00% MwSt.                         13.14\n" +
            "NETTO-UMSATZ                         82.33\n" +
            "------------------------------------------\n" +
            "KontoNr:  0551716000 / 0 / 0512\n" +
            "BLZ:      58862159\n" +
            "Trace-Nr: 027929\n" +
            "Beleg:    7238\n" +
            "------------------------------------------\n" +
            "Kas: 003/006    Bon  0377 PC01 P\n" +
            "Dat: 30.03.2015 Zeit 18:06:01 43\n" +
            "\n").dataUsingEncoding(encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.Center)
        
        builder.appendData((
            "USt–ID:    DE125580123\n" +
            "\n").dataUsingEncoding(encoding))
        
        builder.appendDataWithEmphasis((
            "Vielen dank\n" +
            "für Ihren Einkauf!\n" +
            "\n").dataUsingEncoding(encoding))
        
//      builder.appendBarcodeData("{BStar.".dataUsingEncoding(encoding),              symbology: SCBBarcodeSymbology.Code128, width: SCBBarcodeWidth.Mode2, height: 40, hri: true)
        builder.appendBarcodeData("{BStar.".dataUsingEncoding(NSASCIIStringEncoding), symbology: SCBBarcodeSymbology.Code128, width: SCBBarcodeWidth.Mode2, height: 40, hri: true)
    }
    
    override func appendDotImpact3inchTextReceiptData(builder: ISCBBuilder, utf8: Bool) {
        let encoding: NSStringEncoding
        
        if utf8 == true {
            encoding = NSUTF8StringEncoding
            
            builder.appendCodePage(SCBCodePageType.UTF8)
        }
        else {
            encoding = NSWindowsCP1252StringEncoding
            
            builder.appendCodePage(SCBCodePageType.CP1252)
        }
        
        builder.appendInternational(SCBInternationalType.Germany)
        
        builder.appendAlignment(SCBAlignmentPosition.Center)
        
        builder.appendDataWithMultiple((
            "STAR\n" +
            "Supermarkt\n").dataUsingEncoding(encoding), width: 2, height: 2)
        
        builder.appendData((
            "\n" +
            "Das Internet von seiner\n" +
            "genussvollsten Seite\n" +
            "\n").dataUsingEncoding(encoding))
        
        builder.appendDataWithMultipleHeight(("www.Star-EMEM.com\n").dataUsingEncoding(encoding), height: 2)
        
        builder.appendData(("Gebührenfrei Rufnummer:\n").dataUsingEncoding(encoding))
        
        builder.appendDataWithEmphasis(("08006646701\n").dataUsingEncoding(encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.Left)
        
        builder.appendData(("------------------------------------------\n").dataUsingEncoding(encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.Right)
        
        builder.appendDataWithEmphasis(("EUR\n").dataUsingEncoding(encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.Left)
        
        builder.appendData((
            "Schmand 24%                           0.42\n" +
            "Kefir                                 0.79\n" +
            "Haarspray                             1.79\n" +
            "Gurken ST                             0.59\n" +
            "Mandelknacker                         1.59\n" +
            "Mandelknacker                         1.59\n" +
            "Nussecken                             1.69\n" +
            "Nussecken                             1.69\n" +
            "Clemen.1kg NZ                         1.49\n" +
            "2X\n" +
            "Zitronen ST                           1.18\n" +
            "4X\n" +
            "Grapefruit                            3.16\n" +
            "Party Garnelen                        9.79\n" +
            "Apfelsaft                             1.39\n" +
            "Lauchzw./Schl.B                       0.49\n" +
            "Butter                                1.19\n" +
            "Profi-Haartrockner                   27.99\n" +
            "Mozarella 45%                         0.59\n" +
            "Mozarella 45%                         0.59\n" +
            "Bruschetta Brot                       0.59\n" +
            "Weizenmehl                            0.39\n" +
            "Jodsalz                               0.19\n" +
            "Eier M braun Bod                      1.79\n" +
            "Schlagsahne                           1.69\n" +
            "Schlagsahne                           1.69\n" +
            "\n" +
            "Rueckgeld                        EUR  0.00\n" +
            "\n" +
            "19.00% MwSt.                         13.14\n" +
            "NETTO-UMSATZ                         82.33\n" +
            "------------------------------------------\n" +
            "KontoNr:  0551716000 / 0 / 0512\n" +
            "BLZ:      58862159\n" +
            "Trace-Nr: 027929\n" +
            "Beleg:    7238\n" +
            "------------------------------------------\n" +
            "Kas: 003/006    Bon  0377 PC01 P\n" +
            "Dat: 30.03.2015 Zeit 18:06:01 43\n" +
            "\n").dataUsingEncoding(encoding))
        
        builder.appendAlignment(SCBAlignmentPosition.Center)
        
        builder.appendData((
            "USt–ID:    DE125580123\n" +
            "\n").dataUsingEncoding(encoding))
        
        builder.appendDataWithEmphasis((
            "Vielen dank\n" +
            "für Ihren Einkauf!\n").dataUsingEncoding(encoding))
    }
}
