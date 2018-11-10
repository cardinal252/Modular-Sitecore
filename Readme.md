# Sitecore Bundle Architecture

This represents a helix alternative architecture to allow bundle based deployments in your sitecore solutions

## Fundamentals

NO 2 modules can deliver the same file

All developers have the same publish location, generally we use p drive for source and x drive for runtime code. There are many approaches to achieving having a P and X drive, you can either use the subst command (add it to registry keys to make it permanent), a mounted VHD or a partition.

Conduits are visual studio publishable projects that provide a way of bringing together functionality within a module or kernel group. They are not mandatory, you can have a publishable single project, but it must be modified to accept the DeployWebsite property to control the inbuilt DeployOnBuild (see 'conduits' below)

## Folder Structure

Core - For the most part core assemblies are very low level very generic integrations to encapsulate functionality that is not likely to change unless fundamental elements of Sitecore or the .Net framework change. Examples of this might be unit testable / pluggable wrappers for sending an email (note - not the composition of the email).

Kernel - Kernel is slightly more frequently changed than core, this is likely to be things like SSO type functionality on which your modules can depend. Any kernel changes should mandate a complete redeployment of the solution.

Platform - This is a composition of Sitecore modules plus core & kernel deliverables

Modules - These are units of functionality present within the site, they would represent bundles of functionality that belong together and would be deployed together. They cannot be coupled to other modules except by loose coupling via Sitecore content or IoC containers

Services - The services are responsible for api type functionality. Services can choose not to rely on the platform

Build - This contains scripts to specifically help with automating the generation of the site for developers or the build server.


## Configuration Conventions

App_Config\Connectionstrings.config - this must be controlled by the platform (usually in a kernel or from a build pipeline)
App_Config\Include\<Module Name>\xxx.config
App_Config\Include\zzzDeploy\<Module Name>\xxx.config.deploy
App_Config\Include\zzzDeployCM\<Module Name>\xxx.config.deploy
App_Config\Include\zzzDeployCD\<Module Name>\xxx.config.deploy
App_Config\Include\zzzDeveloper\<Module Name>\xxx.config

## Deployment helpers

DeploymentValidation.ps1 - This publishes all of the source and ensures that the file names are all isolated. In many scenarios, this could be ran by the build server on a CI pipeline to ensure developers haven't broken this rule
CompleteDeploy.ps1 - This is for getting your development environment up to date - it performs a publish of everything thing the source using the Dev profile.

## Project Generation

## Conduits