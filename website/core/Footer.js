/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

const React = require('react');

class Footer extends React.Component {
  docUrl(doc, language) {
    const baseUrl = this.props.config.baseUrl;
    const docsUrl = this.props.config.docsUrl;
    const docsPart = `${docsUrl ? `${docsUrl}/` : ''}`;
    const langPart = `${language ? `${language}/` : ''}`;
    return `${baseUrl}${docsPart}${langPart}${doc}`;
  }

  pageUrl(doc, language) {
    const baseUrl = this.props.config.baseUrl;
    return baseUrl + (language ? `${language}/` : '') + doc;
  }

  render() {
    return (
      <footer className="nav-footer" id="footer">
        <section className="sitemap">
          <a href={this.props.config.baseUrl} className="nav-home">
            {this.props.config.footerIcon && (
              <img
                src={this.props.config.baseUrl + this.props.config.footerIcon}
                alt={this.props.config.title}
                width="66"
                height="58"
                style={{filter:"brightness(0) invert(1)"}}
              />
            )}
          </a>
          <div>
            <h5>Docs</h5>
            <a href={this.docUrl('quick-start.html', this.props.language)}>
              Quick-start
            </a>
            <a href={this.docUrl('deploy.html', this.props.language)}>
              Deploy
            </a>
            <a href={this.docUrl('networks.html', this.props.language)}>
              Usage
            </a>
          </div>
          <div>
            <h5>Community</h5>
            <a href={this.pageUrl('users.html', this.props.language)}>
              User Showcase
            </a>
            <a
              href="http://stackoverflow.com/questions/tagged/chirp"
              target="_blank"
              rel="noreferrer noopener">
              Stack Overflow
            </a>
            <a href="https://github.com/JohnCoene/chirp/issues">Github Issues</a>
          </div>
          <div>
            <h5>More</h5>
            <a href={`${this.props.config.baseUrl}blog`}>Blog</a>
            <a href="https://github.com/JohnCoene/chirp">GitHub</a>
            <a
              className="github-button"
              href={this.props.config.repoUrl}
              data-icon="octicon-star"
              data-count-href="/JohnCoene/chirp/stargazers"
              data-show-count="true"
              data-count-aria-label="# stargazers on GitHub"
              aria-label="Star this project on GitHub">
              Star
            </a>
          </div>
        </section>
        <a href="https://www.buymeacoffee.com/JohnCoene" target="_blank" className="fbOpenSource">
          <img 
            src="https://www.buymeacoffee.com/assets/img/custom_images/black_img.png"
            alt="Buy Me A Coffee"
            style={{height: "auto !important", width: "auto !important"}} />
        </a>
        <section className="copyright">{this.props.config.copyright}</section>
      </footer>
    );
  }
}

module.exports = Footer;
