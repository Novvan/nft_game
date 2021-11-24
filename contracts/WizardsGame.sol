// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/utils/Strings.sol";
import "base64-sol/base64.sol";
import "hardhat/console.sol";

contract WizardsGame is ERC721 {
    struct CharacterAttributes {
        uint256 characterIndex;
        string name;
        string imageURI;
        uint256 hp;
        uint256 maxHp;
        uint256 mana;
        uint256 maxMana;
        uint256 spellDamage;
    }

    using Counters for Counters.Counter;
    Counters.Counter private _tokenIds;

    CharacterAttributes[] defaultWizards;

    mapping(uint256 => CharacterAttributes) public nftHolderAttributes;
    mapping(address => uint256) public nftHolders;

    constructor(
        string[] memory characterNames,
        string[] memory characterImageURIs,
        uint256[] memory characterHp,
        uint256[] memory characterMana,
        uint256[] memory characterSpellDmg
    ) ERC721("Wizards", "WIZ") {
        for (uint256 i = 0; i < characterNames.length; i += 1) {
            defaultWizards.push(
                CharacterAttributes({
                    characterIndex: i,
                    name: characterNames[i],
                    imageURI: characterImageURIs[i],
                    hp: characterHp[i],
                    maxHp: characterHp[i],
                    mana: characterMana[i],
                    maxMana: characterMana[i],
                    spellDamage: characterSpellDmg[i]
                })
            );
            CharacterAttributes memory c = defaultWizards[i];
            console.log(
                "Done initializing %s w/ HP %s, dmg %s",
                c.name,
                c.hp,
                c.spellDamage
            );
        }

        _tokenIds.increment();
    }

    function mintCharacterNFT(uint256 _characterIndex) external {
        uint256 newItemId = _tokenIds.current();

        _safeMint(msg.sender, newItemId);

        nftHolderAttributes[newItemId] = CharacterAttributes({
            characterIndex: _characterIndex,
            name: defaultWizards[_characterIndex].name,
            imageURI: defaultWizards[_characterIndex].imageURI,
            hp: defaultWizards[_characterIndex].hp,
            maxHp: defaultWizards[_characterIndex].maxHp,
            mana: defaultWizards[_characterIndex].mana,
            maxMana: defaultWizards[_characterIndex].maxMana,
            spellDamage: defaultWizards[_characterIndex].spellDamage
        });

        console.log(
            "Minted NFT w/ tokenId %s and characterIndex %s",
            newItemId,
            _characterIndex
        );

        nftHolders[msg.sender] = newItemId;

        _tokenIds.increment();
    }

    function tokenURI(uint256 _tokenId)
        public
        view
        override
        returns (string memory)
    {
        CharacterAttributes memory charAttributes = nftHolderAttributes[
            _tokenId
        ];

        string memory strHp = Strings.toString(charAttributes.hp);
        string memory strMaxHp = Strings.toString(charAttributes.maxHp);
        string memory strMana = Strings.toString(charAttributes.mana);
        string memory strMaxMana = Strings.toString(charAttributes.maxMana);
        string memory strSpellDamage = Strings.toString(
            charAttributes.spellDamage
        );

        string memory json = Base64.encode(
            bytes(
                string(
                    abi.encodePacked(
                        '{"name": "',
                        charAttributes.name,
                        " -- NFT #: ",
                        Strings.toString(_tokenId),
                        '", "description": "This is an NFT that lets people play in the game Metaverse Wizards!", "image": "',
                        charAttributes.imageURI,
                        '", "attributes": [ { "trait_type": "Health Points", "value": ',
                        strHp,
                        ', "max_value":',
                        strMaxHp,
                        '}, { "trait_type": "Mana", "value": ',
                        strMana,
                        ', "max_value":',
                        strMaxMana,
                        '} { "trait_type": "Spell Damage", "value": ',
                        strSpellDamage,
                        "} ]}"
                    )
                )
            )
        );

        string memory output = string(
            abi.encodePacked("data:application/json;base64,", json)
        );

        return output;
    }
}
