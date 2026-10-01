# wallpapers.nix
{ pkgs }:

{
  devotion = pkgs.fetchurl {
    name = "devotion.png";
    url = "https://unsplash.com/photos/OrovnGeyG-A/download?force=true";
    sha256 = "e26e575ca20158d8c9fae4011943c0d6ac310aa5190ef14cd1ad9512194e896b";
  };

  stJoseph = pkgs.fetchurl {
    name = "st-joseph.png";
    url = "https://unsplash.com/photos/ZNQ65OuOxhg/download?force=true";
    sha256 = "1bf730025ab0a3dd87de48d4a8282053f957ae5b3bff023b8c4e814f35d70537";
  };

  queenOfHeavenAndEarth = pkgs.fetchurl {
    name = "queen-of-heaven-and-earth.png";
    url = "https://unsplash.com/photos/io5vL8ymYNw/download?force=true";
    sha256 = "391f323c43b298bb9dabb81f4fe0af128fe99ca952fbd58712890eb2397d29a1";
  };
}
