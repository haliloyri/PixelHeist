# Pixel Heist — 100 open-access artwork candidates

Checked **27 September 2026**. Exactly **100 distinct works**, **41 artists**, **3 museums**. Research pool, not campaign order; original-image implementation status is recorded below. [Turkish companion](PublicDomainArt100.tr.md) · [Structured records and evidence](PublicDomainArt100.json).

## Rights basis and limits

- **Art Institute of Chicago — 58 works:** each API record explicitly reports `is_public_domain=true` and contains `image_id`. The museum's [API copyright guidance](https://api.artic.edu/docs/#copyright) specifically recommends selecting these records. Direct image links follow the documented IIIF pattern. The general licensing webpage returned HTTP 403 during this audit; this catalogue labels these images **public domain according to the museum API**, rather than pretending that the inaccessible policy page was freshly verified.
- **The Metropolitan Museum of Art — 32 works:** each individual record reports `isPublicDomain=true` with a nonempty `primaryImage`. The museum's [image policy](https://www.metmuseum.org/policies/image-resources) places qualifying Open Access images under **CC0** and permits reuse; its metadata licence alone would not be sufficient evidence for an image.
- **Rijksmuseum — 10 works:** each individual object page has **Copyright: Public domain**, links to the [Public Domain Mark](https://creativecommons.org/publicdomain/mark/1.0/), and offers Download image. The museum's [data policy](https://data.rijksmuseum.nl/policy) and [FAQ](https://data.rijksmuseum.nl/about/) explicitly cover commercial reuse. Credit: Rijksmuseum, Amsterdam.
- **Scope:** a practical low-risk research shortlist for commercial pixel reinterpretation, not a guarantee in every country. Distribution countries are not specified. Copyright duration can depend on publication history and jurisdiction; the [US Copyright Office](https://www.copyright.gov/help/faq/faq-duration.html) explains those distinctions. [CC0](https://creativecommons.org/publicdomain/zero/1.0/) also disclaims warranties and does not clear every other right. Confirm the actual release territories and usage before release.
- **Source fidelity:** use the specific museum image identified here, not a stock-photo scan, modern colourisation, copyrighted restoration, museum-room photograph, or an image found by title alone. Museum logos and endorsement are not included. Write original factual captions; this research does not copy museum descriptive prose.
- **Download status (image-only placement, 27 September):** 85/100 research-pool images are bundled with exact-file hashes, including the existing Water Lilies image. 84 newly downloaded pool works plus one supplemental museum work ([Cézanne, The Card Players](https://www.metmuseum.org/art/collection/search/435868)) fill Levels 16–100. Together with the preserved first 15 works, all 100 floor positions have original images. [Campaign placement](CampaignOriginalPlacement.md), `data/artwork_images.json` and [supplemental evidence](SupplementalArtworkSources.json) retain the actual source/rights/download records. Remaining pool candidates are not bundled. No new pixel boards or playable queues were created.

## How to use this list

**★** marks 37 editorial first picks for recognition and variety. This is an assessment, not measured audience recognition. The remaining 63 are supporting works by known masters; all 100 are not claimed to be as recognisable as the Mona Lisa. Six entries are historical Japanese woodblock prints, suitable for framed pixel art, rather than oil paintings. There are 94 paintings in total.

The exact museum object/version is part of each identity. Monet's 1906 *Water Lilies* is the current game's `water_lilies`; do not confuse it with the 1900 *Water Lily Pond*. Van Gogh's Met *Irises* (1890) is a vase composition, not the Getty's 1889 garden painting. Van Gogh's 1887 self-portraits in Chicago and Amsterdam are distinct paintings. Hokusai's *Shower Below the Summit* is not *Red Fuji*. Only one impression of each selected print composition is counted.

The English titles remain usable as game content; Turkish prose here is only a reading companion. Real artworks depicting people do not redefine the game's animal story cast.

## Catalogue

| # | Work (English title; exact museum record) | Artist | Date | Museum / image rights | Image |
| --- | --- | --- | --- | --- | --- |
| 1 | ★ [The Bedroom](https://www.artic.edu/artworks/28560) | Vincent van Gogh | 1889 | AIC · PD | [↗](https://www.artic.edu/iiif/2/6644829f-f292-c5c4-a73c-0356a6fdbf0d/full/843,/0/default.jpg) |
| 2 | [Self-Portrait](https://www.artic.edu/artworks/80607) | Vincent van Gogh | 1887 | AIC · PD | [↗](https://www.artic.edu/iiif/2/47c5bcb8-62ef-e5d7-55e7-f5121f409a30/full/843,/0/default.jpg) |
| 3 | [The Poet's Garden](https://www.artic.edu/artworks/14586) | Vincent van Gogh | 1888 | AIC · PD | [↗](https://www.artic.edu/iiif/2/d4bc1723-7cbc-d36d-a9cb-f84553f2a6f6/full/843,/0/default.jpg) |
| 4 | ★ [Wheat Field with Cypresses](https://www.metmuseum.org/art/collection/search/436535) | Vincent van Gogh | 1889 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP-42549-001.jpg) |
| 5 | ★ [Irises](https://www.metmuseum.org/art/collection/search/436528) | Vincent van Gogh | 1890 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP346474.jpg) |
| 6 | ★ [Self-Portrait with a Straw Hat](https://www.metmuseum.org/art/collection/search/436532) | Vincent van Gogh | 1887 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DT1502_cropped2.jpg) |
| 7 | [Shoes](https://www.metmuseum.org/art/collection/search/436533) | Vincent van Gogh | 1888 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DT1947.jpg) |
| 8 | [Roses](https://www.metmuseum.org/art/collection/search/436534) | Vincent van Gogh | 1890 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP346475.jpg) |
| 9 | [Oleanders](https://www.metmuseum.org/art/collection/search/436530) | Vincent van Gogh | 1888 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DT1494.jpg) |
| 10 | [The Flowering Orchard](https://www.metmuseum.org/art/collection/search/436527) | Vincent van Gogh | 1888 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP-14936-045.jpg) |
| 11 | ★ [Water Lilies](https://www.artic.edu/artworks/16568) | Claude Monet | 1906 | AIC · PD | [↗](https://www.artic.edu/iiif/2/3c27b499-af56-f0d5-93b5-a7f2f1ad5813/full/843,/0/default.jpg) |
| 12 | ★ [Water Lily Pond](https://www.artic.edu/artworks/87088) | Claude Monet | 1900 | AIC · PD | [↗](https://www.artic.edu/iiif/2/8534685d-1102-e1e3-e194-94f6e925e8b0/full/843,/0/default.jpg) |
| 13 | ★ [Arrival of the Normandy Train, Gare Saint-Lazare](https://www.artic.edu/artworks/16571) | Claude Monet | 1877 | AIC · PD | [↗](https://www.artic.edu/iiif/2/0f1cc0e0-e42e-be16-3f71-2022da38cb93/full/843,/0/default.jpg) |
| 14 | ★ [Stacks of Wheat (End of Summer)](https://www.artic.edu/artworks/64818) | Claude Monet | 1890–91 | AIC · PD | [↗](https://www.artic.edu/iiif/2/a38e2828-ec6f-ece1-a30f-70243449197b/full/843,/0/default.jpg) |
| 15 | [Cliff Walk at Pourville](https://www.artic.edu/artworks/14620) | Claude Monet | 1882 | AIC · PD | [↗](https://www.artic.edu/iiif/2/b0effb1c-ff23-bbaa-f809-9fd94e31c1a0/full/843,/0/default.jpg) |
| 16 | [The Beach at Sainte-Adresse](https://www.artic.edu/artworks/14598) | Claude Monet | 1867 | AIC · PD | [↗](https://www.artic.edu/iiif/2/95be2572-b53d-8e7b-abc9-10eb48d4fa5d/full/843,/0/default.jpg) |
| 17 | [Bordighera](https://www.artic.edu/artworks/81537) | Claude Monet | 1884 | AIC · PD | [↗](https://www.artic.edu/iiif/2/4d1b3ad0-14db-0d21-ad9f-17abb8bdfbb5/full/843,/0/default.jpg) |
| 18 | [On the Bank of the Seine, Bennecourt](https://www.artic.edu/artworks/81539) | Claude Monet | 1868 | AIC · PD | [↗](https://www.artic.edu/iiif/2/66f95ea3-a11a-1cf4-6599-d0a49bb25744/full/843,/0/default.jpg) |
| 19 | [Houses of Parliament, London](https://www.artic.edu/artworks/16584) | Claude Monet | 1900–1 | AIC · PD | [↗](https://www.artic.edu/iiif/2/03930df3-1e6c-eeca-8660-c0b22ca477ff/full/843,/0/default.jpg) |
| 20 | [Charing Cross Bridge, London](https://www.artic.edu/artworks/16544) | Claude Monet | 1901 | AIC · PD | [↗](https://www.artic.edu/iiif/2/e9179922-f68d-34c5-481d-abf49e046863/full/843,/0/default.jpg) |
| 21 | ★ [Two Sisters (On the Terrace)](https://www.artic.edu/artworks/14655) | Pierre-Auguste Renoir | 1881 | AIC · PD | [↗](https://www.artic.edu/iiif/2/3a608f55-d76e-fa96-d0b1-0789fbc48f1e/full/843,/0/default.jpg) |
| 22 | [Acrobats at the Cirque Fernando (Francisca and Angelina Wartenberg)](https://www.artic.edu/artworks/81558) | Pierre-Auguste Renoir | 1879 | AIC · PD | [↗](https://www.artic.edu/iiif/2/321c45f5-22a3-84a2-44cc-cf66642d4cf2/full/843,/0/default.jpg) |
| 23 | [Lunch at the Restaurant Fournaise (The Rowers' Lunch)](https://www.artic.edu/artworks/81555) | Pierre-Auguste Renoir | 1875 | AIC · PD | [↗](https://www.artic.edu/iiif/2/1a1b74fe-ff2a-8991-0581-5d420f0b840e/full/843,/0/default.jpg) |
| 24 | [Woman at the Piano](https://www.artic.edu/artworks/25825) | Pierre-Auguste Renoir | 1875–76 | AIC · PD | [↗](https://www.artic.edu/iiif/2/8f06717c-9ede-f22b-d13b-327a50c22f9c/full/843,/0/default.jpg) |
| 25 | [Chrysanthemums](https://www.artic.edu/artworks/16617) | Pierre-Auguste Renoir | 1881–82 | AIC · PD | [↗](https://www.artic.edu/iiif/2/479aff61-784e-e833-fd82-50ba8c819514/full/843,/0/default.jpg) |
| 26 | ★ [The Basket of Apples](https://www.artic.edu/artworks/111436) | Paul Cézanne | c. 1893 | AIC · PD | [↗](https://www.artic.edu/iiif/2/52ac8996-3460-cf71-cb42-5c4d0aa29b74/full/843,/0/default.jpg) |
| 27 | [The Bay of Marseille, Seen from L'Estaque](https://www.artic.edu/artworks/16487) | Paul Cézanne | c. 1885 | AIC · PD | [↗](https://www.artic.edu/iiif/2/d4ca6321-8656-3d3f-a362-2ee297b2b813/full/843,/0/default.jpg) |
| 28 | [Madame Cezanne in a Yellow Chair](https://www.artic.edu/artworks/62371) | Paul Cézanne | 1888–90 | AIC · PD | [↗](https://www.artic.edu/iiif/2/4822cd01-44ac-041a-36b8-c0542377b750/full/843,/0/default.jpg) |
| 29 | [The Vase of Tulips](https://www.artic.edu/artworks/14561) | Paul Cézanne | c. 1890 | AIC · PD | [↗](https://www.artic.edu/iiif/2/96f23681-9701-a668-5c3f-6ffa951f7ecc/full/843,/0/default.jpg) |
| 30 | ★ [The Millinery Shop](https://www.artic.edu/artworks/14572) | Edgar Degas | 1879-86 | AIC · PD | [↗](https://www.artic.edu/iiif/2/6f513908-03cc-b974-633b-adfce56b7936/full/843,/0/default.jpg) |
| 31 | [Yellow Dancers (In the Wings)](https://www.artic.edu/artworks/18951) | Edgar Degas | 1874–76 | AIC · PD | [↗](https://www.artic.edu/iiif/2/8fe022ba-e358-5cda-aa70-d96edd0b4f20/full/843,/0/default.jpg) |
| 32 | [Café Singer](https://www.artic.edu/artworks/84076) | Edgar Degas | 1879 | AIC · PD | [↗](https://www.artic.edu/iiif/2/a867af78-9a29-c75b-33ab-2f21a2d92b3f/full/843,/0/default.jpg) |
| 33 | [The Ballet from "Robert le Diable"](https://www.metmuseum.org/art/collection/search/436123) | Edgar Degas | 1871 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DT1911.jpg) |
| 34 | ★ [A Sunday on La Grande Jatte — 1884](https://www.artic.edu/artworks/27992) | Georges Seurat | 1884–86, border added 1888–89 | AIC · PD | [↗](https://www.artic.edu/iiif/2/2d484387-2509-5e8e-2c43-22f9981972eb/full/843,/0/default.jpg) |
| 35 | [Circus Sideshow (Parade de cirque)](https://www.metmuseum.org/art/collection/search/437654) | Georges Seurat | 1887–88 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP375450_cropped.jpg) |
| 36 | ★ [Paris Street; Rainy Day](https://www.artic.edu/artworks/20684) | Gustave Caillebotte | 1877 | AIC · PD | [↗](https://www.artic.edu/iiif/2/f8fd76e9-c396-5678-36ed-6a348c904d27/full/843,/0/default.jpg) |
| 37 | [The Races at Longchamp](https://www.artic.edu/artworks/81533) | Édouard Manet | 1866 | AIC · PD | [↗](https://www.artic.edu/iiif/2/e9ce5aca-4c34-c8dd-b8a1-91b3e3197211/full/843,/0/default.jpg) |
| 38 | [Woman Reading](https://www.artic.edu/artworks/14591) | Édouard Manet | 1880–82 | AIC · PD | [↗](https://www.artic.edu/iiif/2/fd991fea-0c13-8444-7879-aba467f1d9db/full/843,/0/default.jpg) |
| 39 | [Boating](https://www.metmuseum.org/art/collection/search/436947) | Édouard Manet | 1874 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP-25466-001.jpg) |
| 40 | [Mahana no atua (Day of the God)](https://www.artic.edu/artworks/27943) | Paul Gauguin | 1894 | AIC · PD | [↗](https://www.artic.edu/iiif/2/a4bef587-48a4-d186-813d-f297441b1ab3/full/843,/0/default.jpg) |
| 41 | [Arlésiennes (Mistral)](https://www.artic.edu/artworks/19339) | Paul Gauguin | 1888 | AIC · PD | [↗](https://www.artic.edu/iiif/2/ae6ac285-6887-dd76-4570-d379c786dfae/full/843,/0/default.jpg) |
| 42 | [Ia Orana Maria (Hail Mary)](https://www.metmuseum.org/art/collection/search/438821) | Paul Gauguin | 1891 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DT1025.jpg) |
| 43 | ★ [At the Moulin Rouge](https://www.artic.edu/artworks/61128) | Henri de Toulouse-Lautrec | 1892–95 | AIC · PD | [↗](https://www.artic.edu/iiif/2/defb4004-b500-218d-3d9b-9a02423f097d/full/843,/0/default.jpg) |
| 44 | [Equestrienne (At the Cirque Fernando)](https://www.artic.edu/artworks/16146) | Henri de Toulouse-Lautrec | 1887–88 | AIC · PD | [↗](https://www.artic.edu/iiif/2/65db9e21-83c3-1cc6-7240-1e1996d87f52/full/843,/0/default.jpg) |
| 45 | [Moulin de la Galette](https://www.artic.edu/artworks/14664) | Henri de Toulouse-Lautrec | 1889 | AIC · PD | [↗](https://www.artic.edu/iiif/2/156aaed6-fe3c-a13c-f39e-55f381205929/full/843,/0/default.jpg) |
| 46 | [The Place du Havre, Paris](https://www.artic.edu/artworks/81551) | Camille Pissarro | 1893 | AIC · PD | [↗](https://www.artic.edu/iiif/2/0ff20364-c795-c2ca-c1e8-e5a848f09554/full/843,/0/default.jpg) |
| 47 | [The Crystal Palace](https://www.artic.edu/artworks/110541) | Camille Pissarro | 1871 | AIC · PD | [↗](https://www.artic.edu/iiif/2/4eb368b5-3b66-ae2c-bd4a-2643015e05fc/full/843,/0/default.jpg) |
| 48 | [Haymaking at Éragny](https://www.artic.edu/artworks/87000) | Camille Pissarro | 1892 | AIC · PD | [↗](https://www.artic.edu/iiif/2/b84a9755-ca8d-8bd5-5a59-e910b20e3ba5/full/843,/0/default.jpg) |
| 49 | [The Seine at Port-Marly, Piles of Sand](https://www.artic.edu/artworks/16633) | Alfred Sisley | 1875 | AIC · PD | [↗](https://www.artic.edu/iiif/2/c4425cb6-d8b5-6390-603d-7f802406d05d/full/843,/0/default.jpg) |
| 50 | [Street in Moret](https://www.artic.edu/artworks/81561) | Alfred Sisley | c. 1890 | AIC · PD | [↗](https://www.artic.edu/iiif/2/c233d88b-fe56-6b9e-d5c2-47b9a7386756/full/843,/0/default.jpg) |
| 51 | [Woman at Her Toilette](https://www.artic.edu/artworks/11723) | Berthe Morisot | 1875–80 | AIC · PD | [↗](https://www.artic.edu/iiif/2/78c80988-6524-cec7-c661-a4c0a706d06f/full/843,/0/default.jpg) |
| 52 | [Woman in a Garden](https://www.artic.edu/artworks/153798) | Berthe Morisot | 1882–83 | AIC · PD | [↗](https://www.artic.edu/iiif/2/5edb357d-2e8f-8673-d9e8-4b1150af3895/full/843,/0/default.jpg) |
| 53 | ★ [The Child's Bath](https://www.artic.edu/artworks/111442) | Mary Cassatt | 1893 | AIC · PD | [↗](https://www.artic.edu/iiif/2/3b885ae0-4d46-5fe4-d70a-00474827f02c/full/843,/0/default.jpg) |
| 54 | [On a Balcony](https://www.artic.edu/artworks/26650) | Mary Cassatt | 1878–79 | AIC · PD | [↗](https://www.artic.edu/iiif/2/f0150d21-33ab-f6ea-0d4d-32d459f091fe/full/843,/0/default.jpg) |
| 55 | [Nocturne: Blue and Gold—Southampton Water](https://www.artic.edu/artworks/56905) | James McNeill Whistler | 1872 | AIC · PD | [↗](https://www.artic.edu/iiif/2/50034c7f-ce51-00f1-430e-a6f7efc233fc/full/843,/0/default.jpg) |
| 56 | [Grey and Silver: Old Battersea Reach](https://www.artic.edu/artworks/81574) | James McNeill Whistler | 1863 | AIC · PD | [↗](https://www.artic.edu/iiif/2/f0b3ff64-d68e-3fd2-ffc9-5470eb9fea6e/full/843,/0/default.jpg) |
| 57 | [Fishing Boats with Hucksters Bargaining for Fish](https://www.artic.edu/artworks/4796) | J. M. W. Turner | 1837–38 | AIC · PD | [↗](https://www.artic.edu/iiif/2/8641479e-c93e-f1a8-9925-19be061706da/full/843,/0/default.jpg) |
| 58 | [Valley of Aosta: Snowstorm, Avalanche, and Thunderstorm](https://www.artic.edu/artworks/109938) | J. M. W. Turner | 1836–37 | AIC · PD | [↗](https://www.artic.edu/iiif/2/564e2e3f-eb93-88a7-d265-8fea006facff/full/843,/0/default.jpg) |
| 59 | [Stoke-by-Nayland](https://www.artic.edu/artworks/4758) | John Constable | 1836 | AIC · PD | [↗](https://www.artic.edu/iiif/2/400ce9e8-2f67-44e2-dd68-e6c98880d27f/full/843,/0/default.jpg) |
| 60 | [The Rock of Hautepierre](https://www.artic.edu/artworks/27027) | Gustave Courbet | c. 1869 | AIC · PD | [↗](https://www.artic.edu/iiif/2/e0f47937-a1ee-76b4-6505-35a33119a634/full/843,/0/default.jpg) |
| 61 | [Lion Hunt](https://www.artic.edu/artworks/81505) | Eugène Delacroix | 1860–61 | AIC · PD | [↗](https://www.artic.edu/iiif/2/1299b0e5-6a3d-8039-087b-35bf03caea1a/full/843,/0/default.jpg) |
| 62 | [Still Life with Flowers](https://www.artic.edu/artworks/110982) | Odilon Redon | 1905 | AIC · PD | [↗](https://www.artic.edu/iiif/2/bdb9f780-83be-dd12-191d-54a77c5444ab/full/843,/0/default.jpg) |
| 63 | ★ [The Great Wave off Kanagawa](https://www.artic.edu/artworks/24645) | Katsushika Hokusai | 1830/33 | AIC · PD | [↗](https://www.artic.edu/iiif/2/b3974542-b9b4-7568-fc4b-966738f61d78/full/843,/0/default.jpg) |
| 64 | ★ [Shower Below the Summit](https://www.artic.edu/artworks/87008) | Katsushika Hokusai | c. 1830/33 | AIC · PD | [↗](https://www.artic.edu/iiif/2/bbb6d024-f931-2e2f-eb95-750991834b1c/full/843,/0/default.jpg) |
| 65 | [Cranes on snow-covered pine](https://www.artic.edu/artworks/21720) | Katsushika Hokusai | c. 1834 | AIC · PD | [↗](https://www.artic.edu/iiif/2/cc5fce96-3635-35da-e7fd-a68f4b2a26c3/full/843,/0/default.jpg) |
| 66 | ★ [Sudden Shower over Shin Ohashi Bridge and Atake](https://www.artic.edu/artworks/64447) | Utagawa Hiroshige | 1857 | AIC · PD | [↗](https://www.artic.edu/iiif/2/7e3923a9-e254-8d3f-b377-68d86f6083df/full/843,/0/default.jpg) |
| 67 | ★ [Plum Garden at Kameido](https://www.artic.edu/artworks/26577) | Utagawa Hiroshige | 1857 | AIC · PD | [↗](https://www.artic.edu/iiif/2/89a2332f-be15-8e05-bc79-778738fdc1ef/full/843,/0/default.jpg) |
| 68 | ★ [Kanbara: Evening Snow](https://www.artic.edu/artworks/25613) | Utagawa Hiroshige | c. 1833/34 | AIC · PD | [↗](https://www.artic.edu/iiif/2/c287562e-816e-096c-022a-b05199ba4b8f/full/843,/0/default.jpg) |
| 69 | ★ [The Night Watch](https://www.rijksmuseum.nl/en/collection/SK-C-5) | Rembrandt van Rijn | 1642 | Rijks · PDM | [↗](https://iiif.micr.io/PJEZO/full/843,/0/default.jpg) |
| 70 | ★ [The Milkmaid](https://www.rijksmuseum.nl/en/collection/SK-A-2344) | Johannes Vermeer | c. 1660 | Rijks · PDM | [↗](https://iiif.micr.io/QkOGy/full/843,/0/default.jpg) |
| 71 | ★ [The Syndics](https://www.rijksmuseum.nl/en/collection/SK-C-6) | Rembrandt van Rijn | 1662 | Rijks · PDM | [↗](https://iiif.micr.io/cWWQE/full/843,/0/default.jpg) |
| 72 | [Self-portrait](https://www.rijksmuseum.nl/en/collection/SK-A-3262) | Vincent van Gogh | 1887 | Rijks · PDM | [↗](https://iiif.micr.io/bTpft/full/843,/0/default.jpg) |
| 73 | ★ [The Threatened Swan](https://www.rijksmuseum.nl/en/collection/SK-A-4) | Jan Asselijn | c. 1650 | Rijks · PDM | [↗](https://iiif.micr.io/hZepb/full/843,/0/default.jpg) |
| 74 | ★ [The Windmill at Wijk bij Duurstede](https://www.rijksmuseum.nl/en/collection/SK-C-211) | Jacob van Ruisdael | c. 1668 - c. 1670 | Rijks · PDM | [↗](https://iiif.micr.io/XWEFp/full/843,/0/default.jpg) |
| 75 | ★ [The Little Street](https://www.rijksmuseum.nl/en/collection/SK-A-2860) | Johannes Vermeer | c. 1658 | Rijks · PDM | [↗](https://iiif.micr.io/wcmnK/full/843,/0/default.jpg) |
| 76 | ★ [Woman Reading a Letter](https://www.rijksmuseum.nl/en/collection/SK-C-251) | Johannes Vermeer | c. 1663 | Rijks · PDM | [↗](https://iiif.micr.io/RwfHG/full/843,/0/default.jpg) |
| 77 | ★ [The Jewish Bride](https://www.rijksmuseum.nl/en/collection/SK-C-216) | Rembrandt van Rijn | c. 1665 - c. 1669 | Rijks · PDM | [↗](https://iiif.micr.io/uRWXq/full/843,/0/default.jpg) |
| 78 | [Self-portrait as the Apostle Paul](https://www.rijksmuseum.nl/en/collection/SK-A-4050) | Rembrandt van Rijn | 1661 | Rijks · PDM | [↗](https://iiif.micr.io/wqcDn/full/843,/0/default.jpg) |
| 79 | [Young Woman with a Lute](https://www.metmuseum.org/art/collection/search/437880) | Johannes Vermeer | ca. 1662–63 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP354965.jpg) |
| 80 | [Young Woman with a Water Pitcher](https://www.metmuseum.org/art/collection/search/437881) | Johannes Vermeer | ca. 1662 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP353257.jpg) |
| 81 | [A Maid Asleep](https://www.metmuseum.org/art/collection/search/437878) | Johannes Vermeer | ca. 1656–57 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP355525.jpg) |
| 82 | ★ [Aristotle with a Bust of Homer](https://www.metmuseum.org/art/collection/search/437394) | Rembrandt van Rijn | 1653 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP-30758-001.jpg) |
| 83 | [Self-Portrait](https://www.metmuseum.org/art/collection/search/437397) | Rembrandt van Rijn | 1660 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP-16323-001.jpg) |
| 84 | ★ [Madame X](https://www.metmuseum.org/art/collection/search/12127) | John Singer Sargent | 1883–84 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ad/original/DP-29006-001.jpg) |
| 85 | ★ [The Gulf Stream](https://www.metmuseum.org/art/collection/search/11122) | Winslow Homer | 1899; reworked by 1906 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ad/original/DP-20821-001.jpg) |
| 86 | ★ [Washington Crossing the Delaware](https://www.metmuseum.org/art/collection/search/11417) | Emanuel Leutze | 1851 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ad/original/DP215410.jpg) |
| 87 | ★ [The Oxbow](https://www.metmuseum.org/art/collection/search/10497) | Thomas Cole | 1836 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ad/original/DP-12550-001.jpg) |
| 88 | [The Rocky Mountains, Lander's Peak](https://www.metmuseum.org/art/collection/search/10154) | Albert Bierstadt | 1863 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ad/original/DT82.jpg) |
| 89 | ★ [Heart of the Andes](https://www.metmuseum.org/art/collection/search/10481) | Frederic Edwin Church | 1859 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ad/original/DT78.jpg) |
| 90 | ★ [The Harvesters](https://www.metmuseum.org/art/collection/search/435809) | Pieter Bruegel the Elder | 1565 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP119115.jpg) |
| 91 | [The Vision of Saint John](https://www.metmuseum.org/art/collection/search/436576) | El Greco | ca. 1608–14 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP-17641-001.jpg) |
| 92 | [The Fortune-Teller](https://www.metmuseum.org/art/collection/search/436838) | Georges de La Tour | probably 1630s | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP-14286-015.jpg) |
| 93 | [The Penitent Magdalen](https://www.metmuseum.org/art/collection/search/436839) | Georges de La Tour | ca. 1640 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP-27910-001.jpg) |
| 94 | ★ [The Death of Socrates](https://www.metmuseum.org/art/collection/search/436105) | Jacques Louis David | 1787 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP-13139-001.jpg) |
| 95 | ★ [The Horse Fair](https://www.metmuseum.org/art/collection/search/435702) | Rosa Bonheur | 1852–55 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP-23550-001.jpg) |
| 96 | [The Musicians](https://www.metmuseum.org/art/collection/search/435844) | Caravaggio | 1597 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP-687-001.jpg) |
| 97 | [Hermann von Wedigh III (died 1560)](https://www.metmuseum.org/art/collection/search/436658) | Hans Holbein the Younger | 1532 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP164836.jpg) |
| 98 | [Joan of Arc](https://www.metmuseum.org/art/collection/search/435621) | Jules Bastien-Lepage | 1879 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ep/original/DP-14201-049.jpg) |
| 99 | [Autumn Oaks](https://www.metmuseum.org/art/collection/search/11227) | George Inness | ca. 1878 | Met · CC0 | [↗](https://images.metmuseum.org/CRDImages/ad/original/DT264804.jpg) |
| 100 | [The Herring Net](https://www.artic.edu/artworks/25865) | Winslow Homer | 1885 | AIC · PD | [↗](https://www.artic.edu/iiif/2/5dca7347-c6dc-24dd-d073-d705b9cdc575/full/843,/0/default.jpg) |

## Relationship to the live game and handoff

This list does not automatically replace the existing 15 works. Only *Water Lilies* is explicitly matched to an existing game record; the other current real artworks have not been declared unusable. The first three chapters and five fixed story-fragment identities remain intact.

In particular, the existing *Girl with a Pearl Earring* [Mauritshuis source page](https://www.mauritshuis.nl/en/our-collection/artworks/670-girl-with-a-pearl-earring) requests contact for commercial use of its museum images. That is not a claim that Vermeer's original painting remains copyrighted; it means that specific image source cannot simply be assumed unrestricted. This catalogue also does not clear the Mona Lisa, The Starry Night, The Kiss or the other existing works; their specific image sources need a separate audit.

**Completed:** research of 100 artwork identities, artists, dates, individual institutional rights flags, source records and image paths; 100 unique IDs and image paths validated. Duplicate print impressions were excluded. No runtime or save data changed.

**Remaining:** download and hash exact source assets; assess actual distribution territories; make and visually review pixel adaptations; author and test solvable queues; map into the campaign. **P16-30 stays unchecked.** Next, select Chapter 4–20 content from this pool while preserving the first 15 works and fixed story carriers. Replacing fictional finale artworks with real titles requires aligned English/Turkish story-design edits; never reuse an old save ID for a different artwork.
