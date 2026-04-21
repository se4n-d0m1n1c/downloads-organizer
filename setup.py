#!/usr/bin/env python3
"""
Downloads Folder Organizer - Setup Script
Minimal setup for potential package distribution
"""

from setuptools import setup, find_packages

with open("README.md", "r", encoding="utf-8") as fh:
    long_description = fh.read()

setup(
    name="downloads-organizer",
    version="1.0.0",
    author="Sean Dominic",
    author_email="jiyuuomitometeirushiratori@protonmail.com",
    description="Automated Downloads folder organizer by file type",
    long_description=long_description,
    long_description_content_type="text/markdown",
    url="https://github.com/se4n-d0m1n1c/downloads-organizer",
    packages=find_packages(),
    classifiers=[
        "Programming Language :: Python :: 3",
        "License :: OSI Approved :: MIT License",
        "Operating System :: POSIX :: Linux",
        "Topic :: System :: Filesystems",
        "Topic :: Utilities",
    ],
    python_requires=">=3.6",
    entry_points={
        "console_scripts": [
            "organize-downloads=src.organize_downloads:main",
            "organize-downloads-cron=src.organize_downloads_cron:main",
        ],
    },
)