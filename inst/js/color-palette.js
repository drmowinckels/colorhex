// js API connection from https://github.com/airtoxin/color-hex/

import request from "request-promise";
import cheerio from "cheerio";

export const listPopular = () => {
    return request("http://www.color-hex.com/color-palettes/popular.php")
        .then((body) => {
            const $ = cheerio.load(body);
            const $palettes = $(".palettecontainerlist");
            return $palettes.map((i, pel) => {
                const $palette = $(pel);
                const name = $palette.text().trim();
                const colors = $palette.find(".palettecolordiv").map((i, cel) => {
                    return $(cel).css("background-color");
                }).get();
                const id = $palette.find("a").attr("href").match(/.*color-palette\/(\d+)/)[1];
                return {
                    id,
                    name,
                    colors
                };
            }).get();
        });
};
