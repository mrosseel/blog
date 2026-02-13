const syntaxHighlight = require("@11ty/eleventy-plugin-syntaxhighlight");
const pluginRss = require("@11ty/eleventy-plugin-rss");
const Image = require("@11ty/eleventy-img");
const { DateTime } = require("luxon");
const path = require("path");

module.exports = function (eleventyConfig) {
  eleventyConfig.addPlugin(syntaxHighlight);
  eleventyConfig.addPlugin(pluginRss);

  // YouTube shortcode — privacy-friendly embed
  eleventyConfig.addShortcode("youtube", function (id) {
    return `<div class="youtube-embed"><iframe src="https://www.youtube-nocookie.com/embed/${id}" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen loading="lazy"></iframe></div>`;
  });

  // Image shortcode — responsive avif/webp/jpeg
  eleventyConfig.addAsyncShortcode("image", async function (src, alt, sizes = "(min-width: 42rem) 42rem, 100vw") {
    if (!src) return "";
    const inputPath = this.page?.inputPath || "";
    const inputDir = path.dirname(inputPath);
    const imagePath = path.resolve(inputDir, src);

    const metadata = await Image(imagePath, {
      widths: [480, 800, 1200],
      formats: ["avif", "webp", "jpeg"],
      outputDir: "./_site/img/",
      urlPath: "/img/",
    });

    const imageAttributes = {
      alt: alt || "",
      sizes,
      loading: "lazy",
      decoding: "async",
    };

    return Image.generateHTML(metadata, imageAttributes);
  });

  // Collections
  eleventyConfig.addCollection("posts", function (collectionApi) {
    return collectionApi.getFilteredByGlob("src/posts/**/*.md")
      .filter((item) => !item.data.draft)
      .sort((a, b) => b.date - a.date);
  });

  eleventyConfig.addCollection("tagList", function (collectionApi) {
    const tagSet = new Set();
    collectionApi.getAll().forEach((item) => {
      (item.data.tags || []).forEach((tag) => {
        if (tag !== "posts") tagSet.add(tag);
      });
    });
    return [...tagSet].sort();
  });

  // Filters
  eleventyConfig.addFilter("readableDate", (dateObj) => {
    return DateTime.fromJSDate(dateObj, { zone: "utc" }).toFormat("dd LLLL yyyy");
  });

  eleventyConfig.addFilter("isoDate", (dateObj) => {
    return DateTime.fromJSDate(dateObj, { zone: "utc" }).toISO();
  });

  eleventyConfig.addFilter("head", (array, n) => {
    if (!Array.isArray(array)) return array;
    return n < 0 ? array.slice(n) : array.slice(0, n);
  });

  // Passthrough copy
  eleventyConfig.addPassthroughCopy("src/assets/css");
  eleventyConfig.addPassthroughCopy("src/assets/js");
  eleventyConfig.addPassthroughCopy("src/assets/img");
  eleventyConfig.addPassthroughCopy("src/posts/images");

  return {
    dir: {
      input: "src",
      output: "_site",
      includes: "_includes",
      data: "_data",
    },
    markdownTemplateEngine: "njk",
    htmlTemplateEngine: "njk",
  };
};
