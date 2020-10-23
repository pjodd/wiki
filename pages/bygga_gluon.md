---
title: Bygga Gluon
---

[Följ manualen](http://gluon.readthedocs.io/en/v2017.1.1/user/getting_started.html).

När man uppgraderar till ny version måste även `gluon-site/site.mk`
uppdateras för att reflektera den nya versionen. Utgå från
`docs/site-example/site.mk` och redigera den så att våra inställningar
reflekteras. I skivande stund betyder det att man tar bort språket `DE`
och bara har kvar `EN`, och att det är `EU` som är satt till område.
