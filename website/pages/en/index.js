/**
 * Copyright (c) 2017-present, Facebook, Inc.
 *
 * This source code is licensed under the MIT license found in the
 * LICENSE file in the root directory of this source tree.
 */

const React = require('react');

const CompLibrary = require('../../core/CompLibrary.js');

const MarkdownBlock = CompLibrary.MarkdownBlock; /* Used to read markdown */
const Container = CompLibrary.Container;
const GridBlock = CompLibrary.GridBlock;

class HomeSplash extends React.Component {
  render() {
    const {siteConfig, language = ''} = this.props;
    const {baseUrl, docsUrl} = siteConfig;
    const docsPart = `${docsUrl ? `${docsUrl}/` : ''}`;
    const langPart = `${language ? `${language}/` : ''}`;
    const docUrl = doc => `${baseUrl}${docsPart}${langPart}${doc}`;

    const SplashContainer = props => (
      <div className="homeContainer">
        <div className="homeSplashFade">
          <div className="wrapper homeWrapper">{props.children}</div>
        </div>
      </div>
    );

    const Logo = props => (
      <div className="projectLogo">
        <img src={props.img_src} alt="Project Logo" />
      </div>
    );

    const ProjectTitle = () => (
      <h2 className="projectTitle">
        {siteConfig.title}
        <small>{siteConfig.tagline}</small>
      </h2>
    );

    const PromoSection = props => (
      <div className="section promoSection">
        <div className="promoRow">
          <div className="pluginRowBlock">{props.children}</div>
        </div>
      </div>
    );

    const Button = props => (
      <div className="pluginWrapper buttonWrapper">
        <a className="button" href={props.href} target={props.target}>
          {props.children}
        </a>
      </div>
    );

    return (
      <SplashContainer>
        {/* <Logo img_src={`${baseUrl}img/docusaurus.svg`} /> */}
        <div className="inner">
          <ProjectTitle siteConfig={siteConfig} />
          <PromoSection>
						<Button href={docUrl('quick-start.html')}>Quick Start</Button>
            <Button href="https://github.com/JohnCoene/chirp" target="_blank">Github</Button>
          </PromoSection>
        </div>
      </SplashContainer>
    );
  }
}

class Index extends React.Component {
  render() {
    const {config: siteConfig, language = ''} = this.props;
    const {baseUrl} = siteConfig;

    const Block = props => (
      <Container
        padding={['bottom', 'top']}
        id={props.id}
        background={props.background}>
        <GridBlock
          align="center"
          contents={props.children}
          layout={props.layout}
        />
      </Container>
    );

    const FeatureCallout = () => (
      <div
        className="productShowcaseSection paddingBottom"
        style={{textAlign: 'center'}}>
				<div style={{padding:"30.83% 0 0 0",position:"relative;",maxWidth:"990px",margin:"auto"}}>
          <iframe 
            src="https://player.vimeo.com/video/319599255?autoplay=1&title=0&byline=0&portrait=0&muted=1&loop=1" 
            style={{position:"absolute",top:"0",left:"0",width:"100%",height:"100%"}} 
            frameborder="0"
            webkitallowfullscreen 
            mozallowfullscreen 
            allowfullscreen>
          </iframe>
        </div>
        <script src="https://player.vimeo.com/api/player.js"></script>
				<br/>
				<br/>
				<a href="https://johncoene.shinyapps.io/chirp_demo/" target="_blank" class="button">Demo</a>
        <MarkdownBlock>_Limited to 500 tweets_</MarkdownBlock>
      </div>
    );

    const TryOut = () => (
      <Block background="white">
        {[
          {
            content: 'Chirp is fun to use! It is highly interactive and let\'s you view networks in virtual reality.',
            image: `${baseUrl}img/chirp_vr_example.png`,
            imageAlign: 'left',
            title: 'Fun',
          },
        ]}
      </Block>
    );

    const Description = () => (
      <Block background="white">
        {[
          {
            content:
              'Chirp is fully customisable: make it look however you want.<br><br>- Themes<br>- Fonts<br>- Color palettes',
            image: `${baseUrl}img/chirp_mac_custom.png`,
            imageAlign: 'right',
            title: 'Customisable',
          },
        ]}
      </Block>
    );

    const LearnHow = () => (
      <Block background="white">
        {[
          {
            content: 'Chirp is easy to navigate, understand, and setup; get up and running in under a minute: just _5 lines of code_.',
            image: `${baseUrl}img/chirp_mac_ui.png`,
            imageAlign: 'right',
            title: 'Easy',
          },
        ]}
      </Block>
    );

    const Features = () => (
      <Block layout="fourColumn">
        {[
          {
            content: 'Clean UI to easily explore networks',
            image: `${baseUrl}img/tap.svg`,
            imageAlign: 'top',
            title: 'Intuitive',
          },
          {
            content: 'Tons of insights packed in simple platform',
            image: `${baseUrl}img/creative-idea.svg`,
            imageAlign: 'top',
            title: 'Insightful',
					},
          {
            content: 'Customize all the appearance',
            image: `${baseUrl}img/pencil-case.svg`,
            imageAlign: 'top',
            title: 'Customizable',
          },
        ]}
      </Block>
    );

    const Showcase = () => {
      if ((siteConfig.users || []).length === 0) {
        return null;
      }

      const showcase = siteConfig.users
        .filter(user => user.pinned)
        .map(user => (
          <a href={user.infoLink} key={user.infoLink}>
            <img src={user.image} alt={user.caption} title={user.caption} />
          </a>
        ));

      const pageUrl = page => baseUrl + (language ? `${language}/` : '') + page;

      return (
        <div className="productShowcaseSection paddingBottom">
          <h2>Who is Using This?</h2>
          <p>This project is used by these people</p>
          <div className="logos">{showcase}</div>
          <div className="more-users">
            <a className="button" href={pageUrl('users.html')}>
              More {siteConfig.title} Users
            </a>
          </div>
        </div>
      );
    };

    return (
      <div>
        <HomeSplash siteConfig={siteConfig} language={language} />
        <div className="mainContainer">
					<FeatureCallout />
          <Features />
          <LearnHow />
					<TryOut />
					<Description />
          <Showcase />
        </div>
      </div>
    );
  }
}

module.exports = Index;
