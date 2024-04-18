module Spec where
import PdePreludat
import Library
import Test.Hspec

correrTests :: IO ()
correrTests = hspec $ do
  describe "Test de la función sueldo" $ do
    it "El sueldo base de un titular se calcula correctamente" $ do
      sueldo  "titular" 0 10 `shouldBe` 149000
    it "El sueldo base de un adjunto se calcula correctamente" $ do
      sueldo  "adjunto" 0 10 `shouldBe` 116000
    it "El sueldo base de un ayudante se calcula correctamente" $ do
      sueldo  "ayudante" 0 10 `shouldBe` 66000
    it "La antigüedad nula se calcula correctamente" $ do
      sueldo "titular" 0 10 `shouldBe` 149000
    it "La antigüedad 3 a 5 años se calcula correctamente" $ do
      sueldo "titular" 4 10 `shouldBe` 178800
    it "La antigüedad 5 a 10 años se calcula correctamente" $ do
      sueldo "titular" 7 10 `shouldBe` 193700
    it "La antigüedad 10 a 24 años se calcula correctamente" $ do
      sueldo "titular" 20 10 `shouldBe` 223500
    it "La antigüedad más de 24 años se calcula correctamente" $ do
      sueldo "titular" 30 10 `shouldBe` 327800
    it "La proporcionalidad de horas redondea bien hacia abajo" $ do
      sueldo "titular" 1 14 `shouldBe` 149000
    it "La proporcionalidad de horas redondea bien hacia arriba" $ do
      sueldo "titular" 1 16 `shouldBe` 298000
    it "Un ejemplo completo: Un adjunto con 5 años de antigüedad trabajando 24hs" $ do
      sueldo "adjunto" 5 24 `shouldBe` 301600

